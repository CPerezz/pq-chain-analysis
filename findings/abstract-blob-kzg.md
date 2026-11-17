---
id: abstract-blob-kzg
title: "Abstract: a quantum-forged KZG blob opening lets the batch committer hide the chain's data, locking the USD 8.8M bridged to Abstract"
project: abstract
status: confirmed
severity: LOW
patterns: [PQ-8]
primitives: [kzg]
trigger: trusted-setup
impact: funds-locked
alternative: alternative-exists
role: core
contracts:
- address: "0x2edc71e9991a962c7fe172212d1aa9e50480fbb9"
  implementation: null
  name: DiamondProxy (Abstract ZK chain 2741, ExecutorFacet)
  upgradeable: "yes"
  admin: "ChainAdmin 0xa1f75f491f630037c4ccaa2bfa22363cec05a661 (owner Safe 0x7f3eab9ccf1d8b9705f7ede895d3b4ac1b631063, 4 of 8) sets the DA validator pair; diamond upgrades come from ChainTypeManager 0xc2ee6b6af7d616f6e27ce7f4a451aedc2b0f5f5c (owner ZKsync governance 0xe30dca3047b37dc7d88849de4a4dc07937ad5ab3); read at block 26431459"
  value_usd: 8804084
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 2800
families: []
fix:
  layer: onchain-config
  who_acts: "Abstract's batch committer (the validator behind ValidatorTimelock 0xc62bde55caab102714c6b9f7e29e05d9237efd83, owner Safe 0x7f3eab9ccf1d8b9705f7ede895d3b4ac1b631063): commit with PubdataSource.Calldata through the deployed DA validator; Abstract ChainAdmin 0xa1f75f491f630037c4ccaa2bfa22363cec05a661 (Safe 0x7f3eab9ccf1d8b9705f7ede895d3b4ac1b631063, 4 of 8): point setDAValidatorPair at a DA validator that accepts calldata (keccak) pubdata only; Matter Labs / ZKsync governance to ship such a validator; long term, post-quantum blob DA from the Ethereum protocol"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/abstract-blob-kzg
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: [zksync-blob-kzg]
---

## Summary

Abstract (ZKsync-stack chain 2741) proves that each batch's pubdata was published in EIP-4844 blobs by opening the
blob commitments with the KZG point-evaluation precompile (PQ-8). With the KZG setup trapdoor, whoever commits
batches (the validator behind ValidatorTimelock) can pass the check with blobs that do not contain the proven state
diffs, so nobody else can reconstruct Abstract's state and the USD 8.8M that the shared ZKsync vault holds for Abstract
is stuck. The validity proof still guards the state transition, so nothing is taken through this check. The same DA
validator already accepts calldata pubdata checked with keccak, so the committer can switch to it per batch, and the
chain admin can drop KZG entirely by pointing at a calldata-only validator. Rated LOW: step 4 (a calldata path the
operator can already use in the deployed validator, and a forged opening only withholds data).

## Mechanism

- `ExecutorFacet` (facet of the DiamondProxy `0x2edc71e9…`, protocol version 0.33.0) hands each committed batch's DA
  input to the chain's L1 DA validator, read with `getDAValidatorPair()` = `0x1c715018…` (RollupL1DAValidator,
  verified on Sourcify; deployed through the CREATE2 deployer and shared with ZKsync Era).
- `RollupL1DAValidator.checkDA` reads `pubdataSource` from the operator's input. For `PubdataSource.Blob`,
  `_processBlobDA` → `_getPublishedBlobCommitment` → `_pointEvaluationPrecompile` calls `0x0A` with the blob's
  versioned hash, opening point, claimed value, commitment and proof, and requires `BLS_MODULUS` back
  (`RollupL1DAValidator.sol` lines 105-126 and 182-200). The returned opening commitment becomes part of the batch
  commitment that the SNARK checks.
- For `PubdataSource.Calldata`, `CalldataDA._processCalldataDA` checks `keccak256(pubdata) == fullPubdataHash`
  (lines 86-113); no KZG is involved. The operator picks the source per batch, so a calldata path exists but does not
  remove the blob path.
- Pattern PQ-8. The `Config.sol`/`IExecutor.sol` lines in [`source-excerpts.md`](#source-excerpts-abstract-blob-kzg)
  are the constants of the older in-diamond check; the current check lives in the DA validator above.

## Evidence

- CHECKED (precompile trace, all mainnet transactions to March 2026): KZG point evaluation attributed to this
  diamond, 415 calls in the year (`studies/top-callers-classification/results/curated_contracts.csv`, `txs_y1`).
- CHECKED (verified source on Sourcify, read 2026-11-17): `RollupL1DAValidator.sol` and `CalldataDA.sol` of
  `0x1c715018…`, as quoted above.
- CHECKED (`cast call` at block 26,431,459): `getChainId()` 2741, `getSemverProtocolVersion()` 0.33.0, `getAdmin()`
  ChainAdmin `0xa1f75f49…` (no pending admin), `getDAValidatorPair()` (`0x1c715018…`, `0x…03`), `getVerifier()`
  `0x5d5d33b1…`, `getChainTypeManager()` `0xc2ee6b6a…`, 94,265 batches committed / 94,240 executed; ChainAdmin
  `owner()` = Safe `0x7f3eab9c…` with threshold 4 of 8 owners; ChainTypeManager and Bridgehub `owner()` =
  `0xe30dca30…`; ValidatorTimelock `0xc62bde55…` owner = the same Safe ([`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/abstract-blob-kzg/escrow.json)).
- CHECKED (transactions 0x36f44e98… at block 26,431,431 and 0x42057d38… at block 26,431,188): Abstract commits are
  type-3 transactions to ValidatorTimelock carrying 6 and 5 blobs, and Blockscout shows the diamond calling
  `0x1c715018…` in them; blob DA is in use now.
- CHECKED (escrow at block 26,431,459): `L1AssetTracker 0x7fd8b995….chainBalance(2741, assetId)` for the vault's main
  tokens; see the table below.
- CHECKED (Xatu, any function): 2,800 transactions touched the diamond in 2026-10-16 to 2026-11-16; last 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/abstract-blob-kzg/activity.json)).
- INFERRED: a forged opening only helps the party allowed to commit batches (the validator behind ValidatorTimelock);
  that key is itself ECDSA, so a quantum attacker who also forges it could do the same.

## Impact and exposure

| Contract | Upgradeable | Exposed (escrow) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x2edc71e9…` DiamondProxy (Abstract, chain 2741) | yes | $8.80M | 2026-11-16 | 2,800 |

Escrow: Abstract's bridged assets sit in the shared ZKsync L1NativeTokenVault `0xbed1eb54…`, accounted per chain by
L1AssetTracker `0x7fd8b995…`. At block 26,431,459 Abstract's balances were 4,723.81 ETH ($8.56M at $1,811.62),
10.77M YGG ($200k), 19.17M GUILD ($44k), 2,248 USDC, 40.8 USDT and 0.011 wstETH: $8.80M in total. WBTC, DAI, WETH,
PEPE, MAGIC and KOI read zero; smaller tokens were not checked. Review06 read the same ETH and USDC balances
independently at block 26,431,458. These funds are stuck, not taken, if the chain's data is hidden.

Related contracts: the shared DA validator `0x1c715018…` is listed in `zksync-blob-kzg` (ZKsync Era and other ZK
chains also call it), so it is not repeated here; Abstract's verifier `0x5d5d33b1…` (DualVerifier, BN254 SNARK,
PQ-7) is not in any finding.

## Remediation

- Now: the committer can commit with `PubdataSource.Calldata` through the deployed validator `0x1c715018…`.
- Post-quantum replacement: publish pubdata as calldata, checked with keccak, through an L1 DA validator that rejects
  `PubdataSource.Blob`; later, post-quantum blob commitments if Ethereum adopts them.
- Who acts: Matter Labs / ZKsync governance (`0xe30dca30…`) to provide a calldata-only DA validator (the deployed one
  lets the operator choose blobs); Abstract's ChainAdmin `0xa1f75f49…` (Safe `0x7f3eab9c…`, 4 of 8) to call
  `setDAValidatorPair`. Calldata costs more gas per byte than blobs.
- Protocol change: not needed (post-quantum blob DA would keep blob pricing).
- Users cannot protect themselves inside the chain; withdrawing to L1 removes their funds from the escrow.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: depends on the KZG precompile; only a protocol change replaces it).
- 2026-11-17 review (Review20): HIGH -> MEDIUM, step 4: the current check is in RollupL1DAValidator `0x1c715018…`,
  which also accepts keccak-checked calldata pubdata, so the chain admin can remove KZG by pointing at a calldata-only
  validator without a protocol change. `impact` funds-loss -> funds-locked (only the committer can use a forged
  opening, to hide data; the SNARK still checks the state transition); `alternative` sole -> configurable-verifier;
  escrow measured at $8.80M in L1AssetTracker `0x7fd8b995…` for chain 2741 at block 26,431,459.
- 2026-11-17 rubric correction: MEDIUM -> LOW, step 4: the deployed RollupL1DAValidator `0x1c715018…` already accepts `PubdataSource.Calldata`, which the committer chooses per batch, and a forged opening only withholds data (funds-locked); `alternative` configurable-verifier -> alternative-exists; `protocol_change` helps -> not-needed.

# Source excerpts: abstract-blob-kzg

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x2edc71e9991a962c7fe172212d1aa9e50480fbb9` — DiamondProxy (verified source via sourcify)

### `contracts/common/Config.sol`

```solidity
   82  /// to obtain the L2 block timestamp. Applying this mask is equivalent to calculating modulo 2**128
   83  uint256 constant PACKED_L2_BLOCK_TIMESTAMP_MASK = 0xffffffffffffffffffffffffffffffff;
   84  
   85  /// @dev Address of the point evaluation precompile used for EIP-4844 blob verification.
   86  address constant POINT_EVALUATION_PRECOMPILE_ADDR = address(0x0A);
   87  
   88  /// @dev The overhead for a transaction slot in L2 gas.
   89  /// It is roughly equal to 80kk/MAX_TRANSACTIONS_IN_BATCH, i.e. how many gas would an L1->L2 transaction
   90  /// need to pay to compensate for the batch being closed.
  ...
```

### `contracts/state-transition/chain-interfaces/IExecutor.sol`

```solidity
   54  uint256 constant L2_LOG_VALUE_OFFSET = 56;
   55  
   56  /// @dev BLS Modulus value defined in EIP-4844 and the magic value returned from a successful call to the
   57  /// point evaluation precompile
   58  uint256 constant BLS_MODULUS = 52435875175126190479447740508185965837690552500527637822603658699938581184513;
   59  
   60  /// @dev Packed pubdata commitments.
   61  /// @dev Format: list of: opening point (16 bytes) || claimed value (32 bytes) || commitment (48 bytes) || proof (48 bytes)) = 144 bytes
   62  uint256 constant PUBDATA_COMMITMENT_SIZE = 144;
  ...
```

### `contracts/state-transition/chain-interfaces/IVerifier.sol`

```solidity
   15  interface IVerifier {
   16      /// @dev Verifies a zk-SNARK proof.
   17      /// @return A boolean value indicating whether the zk-SNARK proof is valid.
   18      /// Note: The function may revert execution instead of returning false in some cases.
   19      function verify(
   20          uint256[] calldata _publicInputs,
   21          uint256[] calldata _proof,
   22          uint256[] calldata _recursiveAggregationInput
   23      ) external view returns (bool);
  ...
```
