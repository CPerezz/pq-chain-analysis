---
id: polygon-fflonk-verifier
title: "Polygon Agglayer: a forged fflonk proof for any of 10 state-transition chains finalizes a false exit root and drains the shared AgglayerBridge (~USD 126M)"
project: polygon
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x0775e11309d75aa6b0967917fb0213c5673edf81"
  implementation: null
  name: FflonkVerifier (rollup types 3 and 4; rollups 2, 4, 5, 6, 9, 11, 12)
  upgradeable: "no"
  admin: none; same AgglayerManager timelock can move rollups to another verifier
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-09-22
  txs_30d: 0
- address: "0x455ac63e96e6a64ea59c6da0d8f90fca3f1535ab"
  implementation: null
  name: FflonkVerifier_13 (rollup type 8; no rollup on it now)
  upgradeable: "no"
  admin: none; rollup type 8 not obsolete, so the timelock (or a rollup admin upgrading) can still move a rollup onto it
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-08-05
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: "Polygon: PolygonZkEVMTimelock 0xef1462451c30ea7ad8555386226059fe837ca4ef (3-day delay; proposer Safe 0x242dae44f5d8fb54b198d03a94da45b5a4413e21, 5 of 9) adds a rollup type with a hash-based verifier on AgglayerManager 0x5132a183e9f3cb7c848b0aac5ae0c4f0491b7ab2, calls updateRollup for the 10 chains on fflonk types (or their rollup admins via updateRollupByRollupAdmin), and obsoletes types 3, 4, 6, 7 and 8"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/polygon-fflonk-verifier
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl,out_3.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review14 (AgglayerManager and AgglayerBridge source, rollup registry and bridge reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/polygon-fflonk-verifier/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [polygon-pos-checkpoint-validators]
---

## Summary

Ten Agglayer chains of the "state transition" kind (chain IDs 3776, 4913, 999, 938, 31415, 752025 and others) are still verified on Ethereum
by snarkjs fflonk verifiers on BN254. With the fflonk setup trapdoor, a forged proof for any one of them sets a false
local exit root, and because the L1 AgglayerBridge is one escrow shared by every chain with no per-chain balance check,
claims against that root can take its ~USD 126M (2026-11-17). The verifiers are immutable, but Polygon's timelock can
add a rollup type with another verifier and move the chains: rated MEDIUM (step 4: a new verifier the consumer points
at).

## Mechanism

- `AgglayerManager.verifyBatchesTrustedAggregator(...)` (`onlyRole(_TRUSTED_AGGREGATOR_ROLE)`) →
  `_verifyAndRewardBatches` → `IVerifierRollup(rollup.verifier).verifyProof(proof, [inputSnark])` (AgglayerManager.sol
  lines 1156–1264, implementation `0x15ca…2618`). On success the rollup's state root and local exit root are updated
  and folded into the rollup exit root that the bridge trusts.
- `FflonkVerifier*.verifyProof(bytes32[24] proof, uint256[1] pubSignals)`: snarkjs fflonk, `ecadd`/`ecmul` and the
  final BN254 pairing `e([F]_1 - [E]_1 - [J]_1 + y[W2]_1, [1]_2) == e([W']_1, [x]_2)` (excerpt lines 1163–1167 and
  2064–2068).
- `AgglayerBridge.claimAsset` / `claimMessage` (`0x2a3d…2ede`, implementation `0x66e0…c5ad`) verify a Merkle proof
  against the global exit root (`_verifyLeafBridge`); there is no per-origin-chain balance limit in the contract.
- An attacker also needs the trusted aggregator's ECDSA key (or the role) to submit the proof; a CRQC recovers that
  key too. Pattern PQ-7.

## Evidence

- CHECKED (Sourcify verified source of the three verifiers): fflonk pairing check
  ([`source-excerpts.md`](#source-excerpts-polygon-fflonk-verifier)).
- CHECKED (Blockscout verified source of AgglayerManager `0x15ca…2618` and AgglayerBridge `0x66e0…c5ad`, read
  2026-11-17): the functions above; no balance accounting in `claimAsset`.
- CHECKED (cast at block 26,431,492): `rollupTypeMap(1..14)`, `rollupIDToRollupDataV2Deserialized(1..31)`: types 3/4
  use `0x0775…`, 6/7 use `0x9b96…`, 8 uses `0x455a…`; rollups 2, 4, 5, 6, 9, 11, 12 on `0x0775…`, rollups 8, 13, 15 on
  `0x9b96…`, none on `0x455a…`; rollup 1 (chain 1101, Polygon zkEVM) and 20 others are on rollupVerifierType 2
  (ALGateway). EIP-1967 admin of AgglayerManager and AgglayerBridge: ProxyAdmin `0x0f99…cc4a`, owner timelock
  `0xef14…a4ef` (`getMinDelay()` = 259200; PROPOSER_ROLE: Safe `0x242d…3e21`, threshold 5 of 9). Timelock holds
  DEFAULT_ADMIN_ROLE, ADD_ROLLUP_TYPE_ROLE, UPDATE_ROLLUP_ROLE ([`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/polygon-fflonk-verifier/escrow.json)).
- CHECKED (precompile trace, `data/agg/alltime_caller.parquet`): pairing calls `0x9b96…` 26,155 (to block 24,683,537),
  `0x0775…` 54,272 (last 2025-09-22), `0x455a…` 7,882 (last 2025-08-05); `0x9b96…` last called 2026-09-15
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/polygon-fflonk-verifier/activity.json)).

## Impact and exposure

| Contract | Chains on it | Upgradeable | Exposed (escrow) | Last active | 30-day txs |
|---|---|---|---|---|---|
| `0x9b9671db…` FflonkVerifier_12 | 3 (31415, 752025, 623) | no (repointable) | USD 125.8M (shared) | 2026-09-15 | 0 |
| `0x0775e113…` FflonkVerifier | 7 (3776, 4913, 999, 938, …) | no (repointable) | same escrow | 2025-09-22 | 0 |
| `0x455ac63e…` FflonkVerifier_13 | 0 (type 8 not obsolete) | no | same escrow | 2025-08-05 | 0 |

Escrow: AgglayerBridge `0x2a3dd3eb…2ede` on 2026-11-17: 3,522.0 ETH (USD 6.4M) and USD 119.4M in tokens at Blockscout
prices, total USD 125.8M; USD 99.9M of it is HAUST (USD 87.0M) and LUMIA (USD 12.9M), whose prices may not be
realisable; USDT 5.78M, USDC 4.00M, weETH, WBTC follow. The verifiers hold nothing.

Siblings: `0xd941fb73…` (same FflonkVerifier_12 bytecode) belongs to a separate CDK deployment with its own
RollupManager, not to this one (`unidentified-d941fb73-snark-verifier`). Chains on ALGateway verify through
AggLayerGateway `0x046b…74b3`, not covered here.

## Remediation

- Deploy a hash-based verifier (or move the chains to a post-quantum aggregation path), add it as a rollup type with
  `addNewRollupType`, move the 10 chains with `updateRollup` (timelock `0xef14…a4ef`, 3-day delay, Safe `0x242d…3e21`)
  or let rollup admins do it with `updateRollupByRollupAdmin`, and `obsoleteRollupType` types 3, 4, 6, 7 and 8 so no
  chain can return to them. Chains that are dormant can also be frozen.
- No protocol change needed. Users can withdraw bridged assets.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review14): MEDIUM kept, step 4 (Polygon timelock repoints rollup types). Consumers enumerated from AgglayerManager; escrow measured: shared AgglayerBridge USD 125.8M. `0xd941fb73…` checked and found not to be Polygon's.

# Source excerpts: polygon-fflonk-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x9b9671db83cfcb4508bf361942488c5ca2b1286d` — FflonkVerifier_12 (verified source via sourcify)

### `contracts/verifiers/FflonkVerifier_12.sol`

```solidity
  182      uint16 constant pEval_l1 = 1888;
  183  
  184      uint16 constant lastMem = 1920;
  185  
  186      function verifyProof(
  187          bytes32[24] calldata proof,
  188          uint256[1] calldata pubSignals
  189      ) public view returns (bool) {
  190          assembly {
  ...
 2061                  g1_mulAcc(add(pMem, pJ), pW1, numerator)
 2062              }
 2063  
 2064              // Validate all evaluations with a pairing checking that e([F]_1 - [E]_1 - [J]_1 + y[W2]_1, [1]_2) == e([W']_1, [x]_2)
 2065              function checkPairing(pMem) -> isOk {
 2066                  let mIn := mload(0x40)
 2067  
 2068                  // First pairing value
 2069                  // Compute -E
  ...
 2148              // Compute full batched polynomial commitment [F]_1, group-encoded batch evaluation [E]_1 and the full difference [J]_1
 2149              computeFEJ(pMem)
 2150  
 2151              // Validate all evaluations
 2152              let isValid := checkPairing(pMem)
 2153  
 2154              mstore(0, isValid)
 2155              return(0, 0x20)
 2156          }
  ...
```


## Contract `0x0775e11309d75aa6b0967917fb0213c5673edf81` — FflonkVerifier (verified source via sourcify)

### `contracts/verifiers/FflonkVerifier.sol`

```solidity
  158      
  159      uint16 constant lastMem = 1920;
  160       
  161  
  162      function verifyProof(bytes32[24] calldata proof, uint256[1] calldata pubSignals) public view returns (bool) {
  163          assembly {
  164              // Computes the inverse of an array of values
  165              // See https://vitalik.ca/general/2018/07/21/starks_part_3.html in section where explain fields operations
  166              // To save the inverse to be computed on chain the prover sends the inverse as an evaluation in commits.eval_inv
  ...
 1160                  g1_mulAcc(add(pMem, pJ), pW1, numerator)
 1161              }
 1162  
 1163              // Validate all evaluations with a pairing checking that e([F]_1 - [E]_1 - [J]_1 + y[W2]_1, [1]_2) == e([W']_1, [x]_2)
 1164              function checkPairing(pMem) -> isOk {
 1165                  let mIn := mload(0x40)
 1166  
 1167                  // First pairing value
 1168                  // Compute -E
  ...
 1234              // Compute full batched polynomial commitment [F]_1, group-encoded batch evaluation [E]_1 and the full difference [J]_1
 1235              computeFEJ(pMem)
 1236  
 1237              // Validate all evaluations
 1238              let isValid := checkPairing(pMem)
 1239  
 1240              mstore(0, isValid)
 1241              return(0, 0x20)
 1242          }
  ...
```


## Contract `0x455ac63e96e6a64ea59c6da0d8f90fca3f1535ab` — FflonkVerifier_13 (verified source via sourcify)

### `contracts/verifiers/FflonkVerifier_13.sol`

```solidity
  158      
  159      uint16 constant lastMem = 1920;
  160       
  161  
  162      function verifyProof(bytes32[24] calldata proof, uint256[1] calldata pubSignals) public view returns (bool) {
  163          assembly {
  164              // Computes the inverse of an array of values
  165              // See https://vitalik.ca/general/2018/07/21/starks_part_3.html in section where explain fields operations
  166              // To save the inverse to be computed on chain the prover sends the inverse as an evaluation in commits.eval_inv
  ...
 1160                  g1_mulAcc(add(pMem, pJ), pW1, numerator)
 1161              }
 1162  
 1163              // Validate all evaluations with a pairing checking that e([F]_1 - [E]_1 - [J]_1 + y[W2]_1, [1]_2) == e([W']_1, [x]_2)
 1164              function checkPairing(pMem) -> isOk {
 1165                  let mIn := mload(0x40)
 1166  
 1167                  // First pairing value
 1168                  // Compute -E
  ...
 1234              // Compute full batched polynomial commitment [F]_1, group-encoded batch evaluation [E]_1 and the full difference [J]_1
 1235              computeFEJ(pMem)
 1236  
 1237              // Validate all evaluations
 1238              let isValid := checkPairing(pMem)
 1239  
 1240              mstore(0, isValid)
 1241              return(0, 0x20)
 1242          }
  ...
```
