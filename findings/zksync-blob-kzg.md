---
id: zksync-blob-kzg
title: "ZKsync (Matter Labs): with the KZG trapdoor a ZK chain's committer could claim blob data it never published, through the shared RollupL1DAValidator contracts; calldata DA is the fallback"
project: zksync
status: confirmed
severity: LOW
patterns: [PQ-8]
primitives: [kzg]
trigger: trusted-setup
impact: funds-locked
alternative: alternative-exists
role: core
contracts:
- address: "0x1c715018c5565eacc758236d4a9a760162a84cbd"
  implementation: null
  name: RollupL1DAValidator (ZKsync Era, Sophon, Abstract, Lens)
  upgradeable: "no"
  admin: "none (immutable); each chain's admin selects the DA validator pair with setDAValidatorPair on its diamond (ZKsync Era: ChainAdmin 0x2cf3bd6a9056b39999f3883955e183f655345063, owner Safe 0x4e4943346848c4867f81dfb37c4ca9c5715a7828, 4 of 7)"
  value_usd: 84711012
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: null
  txs_30d: null
- address: "0x72213dfe8ca61b0a782970dcfebfb877778f9119"
  implementation: null
  name: RollupL1DAValidator (ZERO Network, zkXPLA, ZKsync Gateway and chains 1345, 2904)
  upgradeable: "no"
  admin: "none (immutable); each chain's admin selects the DA validator pair with setDAValidatorPair on its diamond"
  value_usd: 407778
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-10
  txs_30d: 1471
families: []
fix:
  layer: onchain-config
  who_acts: "each ZK chain's operator (commits with PubdataSource.Calldata instead of Blob) or chain admin (setDAValidatorPair to a calldata-only validator); for ZKsync Era the ChainAdmin 0x2cf3bd6a9056b39999f3883955e183f655345063 (Safe 0x4e4943346848c4867f81dfb37c4ca9c5715a7828); a post-quantum blob scheme needs an Ethereum protocol change"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zksync-blob-kzg
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review06 (Claude), 2026-11-17 review
  ref: Sourcify sources of both validators; Bridgehub and diamond reads at block 26,431,458; L1AssetTracker chain balances
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [zksync-plonk-fflonk-verifier, zksync-lite-plonk-verifier, abstract-blob-kzg]
---

## Summary

ZK Stack chains that post data in EIP-4844 blobs bind each blob to their batch with a KZG point-evaluation opening
checked in a shared `RollupL1DAValidator`. With the KZG ceremony trapdoor, a chain's committer could open a blob
commitment to data it never published, so the batch's state proof would rest on data nobody can download: the chain's
users could not reconstruct state, and funds would be stuck. Only the permissioned committer submits batches, and the
SNARK still checks the state transition, so nothing is stolen through this check. The chains using these validators
have USD 85.1M in ETH and USDC on L1 (Abstract excluded; it is in `abstract-blob-kzg`). Rated LOW: step 4: the
deployed validator already accepts calldata DA, which the operator can choose per batch (or the chain admin can make
the only option with a calldata-only validator pair), and a forged opening only withholds data.

## Mechanism

- `checkDA` (`RollupL1DAValidator.sol` line 58) is called by a chain's diamond when a batch is committed. The first
  byte of the operator's DA input picks `PubdataSource.Blob` (line 76) or `PubdataSource.Calldata` (line 78).
- Blob path: `_processBlobDA` → `_getPublishedBlobCommitment` (line 105) → `_pointEvaluationPrecompile` calls
  precompile 0x0a with the versioned hash, opening point, claimed value, commitment and proof (line 189) and requires
  the BLS modulus as result. `publishBlobs` (line 29) pre-registers commitments the same way. The resulting
  `blobsOpeningCommitments` go into the batch commitment the SNARK proof covers.
- Calldata path: `_processCalldataDA` (`CalldataDA.sol` line 86) checks the full pubdata against the hash from the
  L2 DA validator, with no KZG.
- A chain's admin can also replace the DA validator pair (`setDAValidatorPair` on the diamond's AdminFacet); several
  chains already use calldata-only or validium validators (table below).
- Pattern PQ-8. The forged opening breaks data availability, not validity.

## Evidence

- CHECKED (verified source on Sourcify, both addresses, contract `RollupL1DAValidator`): the paths and line numbers
  above (0x1c715018… is a newer build with the same functions).
- CHECKED (block 26,431,458): `Bridgehub.getAllZKChainChainIDs()` lists 22 chains; `getDAValidatorPair()` on each
  diamond: 0x1c715018… for chains 324, 50104, 2741, 232; 0x72213dfe… for 543210, 1345, 2904, 375, 9075; the others
  use ValidiumL1DAValidator (0x907b3040…, 0xac0f6bf7…), AvailL1DAValidator (0x8f50d93b…) or
  BlobsL1DAValidatorZKsyncOS (0x5ec30c00…, which checks `blobhash` but makes no point-evaluation call)
  ([`zk-stack-state.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zksync-blob-kzg/zk-stack-state.json)).
- CHECKED (`L1AssetTracker` 0x7fd8b995… `chainBalance(chainId, assetId)` for ETH and USDC, block 26,431,458; ETH
  USD 1,811.62): see the table; `settlementLayer(chainId)` = 1 (Ethereum) for every chain.
- CHECKED (Xatu, any function): 0x72213dfe… had 1,471 transactions in 2026-10-16 to 2026-11-16, last on 2026-11-10
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zksync-blob-kzg/activity.json)); `curated_contracts.csv`: 54,354 point-evaluation
  calls in the last year. 0x1c715018… was deployed after the trace window; its activity was not measured.
- INFERRED: chain names from chainid.network (324 ZKsync Era, 50104 Sophon, 2741 Abstract, 232 Lens, 543210 ZERO
  Network, 375 zkXPLA); 9075 is the ZKsync Gateway (ZKsync docs), 1345 and 2904 have no registry entry.

## Impact and exposure

| Contract | Chains | ETH + USDC on L1 (2026-11-17) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x1c715018…` RollupL1DAValidator | 324, 50104, 232 (and 2741, counted in `abstract-blob-kzg`) | $84.71M | not measured | not measured |
| `0x72213dfe…` RollupL1DAValidator | 543210, 1345, 2904, 375, 9075 | $0.41M | 2026-11-10 | 1,471 |

- Escrow: all chains' L1 funds sit in the shared `L1NativeTokenVault` 0xbed1eb542f9a5aa6419ff3deb921a372681111f6
  (USD 127.05M in total on 2026-11-17, Blockscout), with per-chain limits in `L1AssetTracker` 0x7fd8b995…. The values
  above are ETH plus USDC chain balances only (other tokens per chain not read), so they are lower bounds of what
  would be locked. ZKsync Era alone: 35,435 ETH and 20.38M USDC.
- Impact is `funds-locked`: the committer is permissioned (ValidatorTimelock), and the ZK proof still enforces valid
  state transitions; a forged opening hides the data, it does not create value.

## Remediation

- Fallback available now: operators commit with `PubdataSource.Calldata` (same validator), or chain admins set a
  calldata-only validator pair. This costs more gas but removes the KZG dependency.
- Long term: post-quantum data availability in Ethereum (a hash-based blob commitment) would let chains keep blobs;
  that needs a protocol change, but removing the KZG dependency does not, so `protocol_change` is `not-needed`.
- Who acts: each chain's operator or admin; for ZKsync Era the ChainAdmin 0x2cf3bd6a… owned by Matter Labs Safe
  0x4e494334… (4 of 7).

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: depends on the KZG precompile; only a protocol change replaces it).
- 2026-11-17 review (Review06): HIGH -> MEDIUM, step 4 (revised rubric): `checkDA` accepts calldata DA and chain admins can switch DA validators, so no protocol change is needed to drop KZG. Impact funds-loss -> funds-locked (only the committer can submit; the SNARK still checks validity). Added the live validator 0x1c715018… (Era, Sophon, Abstract, Lens); escrow measured from L1AssetTracker chain balances.
- 2026-11-17 rubric correction: MEDIUM -> LOW, step 4: the deployed `RollupL1DAValidator.checkDA` already accepts `PubdataSource.Calldata`, which the operator chooses per batch (the chain admin can also set a calldata-only validator pair), and a forged opening only withholds data (funds-locked); `protocol_change` helps -> not-needed.

# Source excerpts: zksync-blob-kzg

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x72213dfe8ca61b0a782970dcfebfb877778f9119` — RollupL1DAValidator (verified source via sourcify)

### `contracts/DAUtils.sol`

```solidity
   14  }
   15  
   16  /// @dev BLS Modulus value defined in EIP-4844 and the magic value returned from a successful call to the
   17  /// point evaluation precompile
   18  uint256 constant BLS_MODULUS = 52435875175126190479447740508185965837690552500527637822603658699938581184513;
   19  
   20  /// @dev Packed pubdata commitments.
   21  /// @dev Format: list of: opening point (16 bytes) || claimed value (32 bytes) || commitment (48 bytes) || proof (48 bytes)) = 144 bytes
   22  uint256 constant PUBDATA_COMMITMENT_SIZE = 144;
  ...
   30  /// @dev For each blob we expect that the commitment is provided as well as the marker whether a blob with such commitment has been published before.
   31  uint256 constant BLOB_DA_INPUT_SIZE = PUBDATA_COMMITMENT_SIZE + 32;
   32  
   33  /// @dev Address of the point evaluation precompile used for EIP-4844 blob verification.
   34  address constant POINT_EVALUATION_PRECOMPILE_ADDR = address(0x0A);
   35  
   36  /// @dev The address of the special smart contract that can send arbitrary length message as an L2 log
   37  address constant L2_TO_L1_MESSENGER_SYSTEM_CONTRACT_ADDR = address(0x8008);
  ...
```

### `contracts/RollupL1DAValidator.sol`

```solidity
    5  import {IL1DAValidator, L1DAValidatorOutput} from "./IL1DAValidator.sol";
    6  
    7  import {CalldataDA} from "./CalldataDA.sol";
    8  
    9  import {PubdataSource, BLS_MODULUS, PUBDATA_COMMITMENT_SIZE, PUBDATA_COMMITMENT_CLAIMED_VALUE_OFFSET, PUBDATA_COMMITMENT_COMMITMENT_OFFSET, BLOB_DA_INPUT_SIZE, POINT_EVALUATION_PRECOMPILE_ADDR} from "./DAUtils.sol";
   10  
   11  import {InvalidPubdataSource, PubdataCommitmentsEmpty, InvalidPubdataCommitmentsSize, BlobHashCommitmentError, EmptyBlobVersionHash, NonEmptyBlobVersionHash, PointEvalCallFailed, PointEvalFailed, BlobCommitmentNotPublished} from "./DAContractsErrors.sol";
   12  
   13  uint256 constant BLOBS_SUPPORTED = 6;
  ...
  114          bytes32 openingPoint = bytes32(
  115              uint256(uint128(bytes16(_commitment[:PUBDATA_COMMITMENT_CLAIMED_VALUE_OFFSET])))
  116          );
  117  
  118          _pointEvaluationPrecompile(
  119              blobVersionedHash,
  120              openingPoint,
  121              _commitment[PUBDATA_COMMITMENT_CLAIMED_VALUE_OFFSET:PUBDATA_COMMITMENT_SIZE]
  122          );
  ...
  178      /// @notice Calls the point evaluation precompile and verifies the output
  179      /// Verify p(z) = y given commitment that corresponds to the polynomial p(x) and a KZG proof.
  180      /// Also verify that the provided commitment matches the provided versioned_hash.
  181      ///
  182      function _pointEvaluationPrecompile(
  183          bytes32 _versionedHash,
  184          bytes32 _openingPoint,
  185          bytes calldata _openingValueCommitmentProof
  186      ) internal view {
  187          bytes memory precompileInput = abi.encodePacked(_versionedHash, _openingPoint, _openingValueCommitmentProof);
  188  
  189          (bool success, bytes memory data) = POINT_EVALUATION_PRECOMPILE_ADDR.staticcall(precompileInput);
  190  
  191          // We verify that the point evaluation precompile call was successful by testing the latter 32 bytes of the
  192          // response is equal to BLS_MODULUS as defined in https://eips.ethereum.org/EIPS/eip-4844#point-evaluation-precompile
  193          if (!success) {
  194              revert PointEvalCallFailed(precompileInput);
  195          }
  196          (, uint256 result) = abi.decode(data, (uint256, uint256));
  197          if (result != BLS_MODULUS) {
  198              revert PointEvalFailed(abi.encode(result));
  199          }
  200      }
  201  
  ...
```
