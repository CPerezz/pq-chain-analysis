---
id: unidentified-d941fb73-snark-verifier
title: "Standalone Polygon CDK validium (chain 762419583): a forged fflonk proof could finalize false state on its own RollupManager, whose bridge holds nothing priced; dormant since 2025-04"
project: unidentified-d941fb73
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0xd941fb73ac5bab219915c170f9355ac2f6ac7947"
  implementation: null
  name: FflonkVerifier_12
  upgradeable: "no"
  admin: none; RollupManager 0x879f5504acdaa8529618be136b3672be583ebb93 (ProxyAdmin 0xf1f78417795565b7d710c7f3f8a203f586d5e12f, owner PolygonZkEVMTimelock 0x3dedc8fabbd2a440cbce479ea3c2458f4758f62e, 60 s delay, proposer EOA 0xf91b53b5588c09442cfaaf8f921d8321b7d4649e) can add a rollup type with another verifier
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2025-04-07
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: "Chain operator: PolygonZkEVMTimelock 0x3dedc8fabbd2a440cbce479ea3c2458f4758f62e (proposer EOA 0xf91b53b5588c09442cfaaf8f921d8321b7d4649e) adds a rollup type with a hash-based verifier on RollupManager 0x879f5504acdaa8529618be136b3672be583ebb93 and updates rollup 1, or retires the chain"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-d941fb73-snark-verifier
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
  who: Review14 (deployer history, RollupManager and bridge reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-d941fb73-snark-verifier/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

This FflonkVerifier_12 is the only verifier of a standalone Polygon CDK validium (chain ID 762419583) that runs its
own RollupManager, bridge and timelock; it is not part of Polygon's shared Agglayer. With the BN254 setup trapdoor, a
forged proof (submitted with the trusted aggregator's key) could finalize a false exit root and drain that chain's
bridge, but the bridge holds nothing priced and the verifier has not been called since 2025-04-07. Rated LOW (step 1:
no activity in 12 months and nothing held).

## Mechanism

- RollupManager `0x879f…bb93` has one rollup type (forkID 12, verifier `0xd941fb73…`) and one rollup (`0x91d3…0343`,
  chain ID 762419583, a validium with a data committee). Batch verification in the Polygon RollupManager calls
  `IVerifierRollup(rollup.verifier).verifyProof(proof, [inputSnark])`; the verified state sets the rollup's local exit
  root, which the chain's bridge `0x0a30…d0e6` accepts for claims.
- `FflonkVerifier_12.verifyProof` (snarkjs fflonk, Sourcify verified) checks the proof with `ecadd`/`ecmul` and a
  final BN254 `ecpairing` against the fflonk SRS ([`source-excerpts.md`](#source-excerpts-unidentified-d941fb73-snark-verifier)).
- Pattern PQ-7.

## Evidence

- CHECKED (Sourcify verified source): FflonkVerifier_12 pairing check (excerpt).
- CHECKED (Blockscout, deployer `0xf91b…649e` transactions): on 2025-02-13 it created this verifier, called
  `addNewRollupType` and `createNewRollup` on RollupManager `0x879f…bb93`, set the data-availability protocol and data
  committee, and made a zero-value `bridgeAsset` on bridge `0x0a30…d0e6` ([`notes.md`](#review-notes-unidentified-d941fb73-snark-verifier-2026-11-17-review14)).
- CHECKED (cast via eth.drpc.org at block 26,431,595): `rollupCount()` = 1, `rollupTypeMap(1)` and
  `rollupIDToRollupData(1)` point to `0xd941fb73…`; last sequenced and verified batch 1278; ProxyAdmin
  `0xf1f7…e12f` owned by PolygonZkEVMTimelock `0x3ded…f62e` (`getMinDelay()` = 60, proposer = the deployer EOA).
- CHECKED (cast): Polygon's AgglayerManager `0x5132…7ab2` does not use this verifier in any of its 14 rollup types, so
  this contract does not belong in `polygon-fflonk-verifier`.
- CHECKED (precompile trace): 429 pairing calls, blocks 21,836,729–22,217,151 (last 2025-04-07); no calls since
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-d941fb73-snark-verifier/activity.json)).
- INFERRED: the chain may be AIRAS (the bridge holds only AIRAS tokens and L2BEAT lists an archived "AIRAS" project);
  no direct link was found, so the project stays unidentified.

## Impact and exposure

| Contract | Upgradeable | Exposed (escrow) | Last active | 30-day txs |
|---|---|---|---|---|
| `0xd941fb73…` FflonkVerifier_12 | no (repointable by the chain's timelock) | USD 0 | 2025-04-07 | 0 |

Escrow: the chain's bridge `0x0a3014e1…d0e6` holds 0 ETH and 9.499 AIRAS (no market price) on 2026-11-17; the
RollupManager and rollup contracts hold nothing. Same bytecode as Polygon's `0x9b9671db…` (in
`polygon-fflonk-verifier`), deployed separately.

## Remediation

- The chain's timelock `0x3ded…f62e` (proposer: deployer EOA `0xf91b…649e`, 60 s delay) can add a rollup type with a
  hash-based verifier and move rollup 1 to it, or retire the chain. No protocol change needed.
- Nothing for users to do beyond not bridging to this chain.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-04-07) and nothing held).
- 2026-11-17 review (Review14): LOW kept, step 1. Consumer identified as a standalone CDK validium (own RollupManager `0x879f…bb93`, chain ID 762419583), not Polygon's Agglayer; project still unidentified (possibly AIRAS). Escrow measured: nothing priced.
- 2026-11-19: LOW -> MEDIUM, step 1 removed (dormancy no longer lowers a rating); step 4 gives MEDIUM: a new verifier the consumer points at.

# Source excerpts: unidentified-d941fb73-snark-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xd941fb73ac5bab219915c170f9355ac2f6ac7947` — FflonkVerifier_12 (verified source via sourcify)

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

# Review notes: unidentified-d941fb73-snark-verifier (2026-11-17, Review14)

## Consumer: a standalone Polygon CDK stack, not Polygon's shared RollupManager

Deployer `0xf91b53b5588c09442cfaaf8f921d8321b7d4649e` (EOA, funded 2025-02-13 by `0xdd114377c59d115d4e1d7d2ab80f0269025a137a`,
which also created the timelock below). Its 14 transactions (Blockscout), all 2025-02-13/14:

| Block | Action |
|---|---|
| 21,836,468 / 21,836,477 | `schedule` / `execute` on PolygonZkEVMTimelock `0x3dedc8fabbd2a440cbce479ea3c2458f4758f62e` |
| 21,836,484 | creates FflonkVerifier_12 `0xd941fb73…` |
| 21,836,485 | creates `0x3894f976728b57a6843e34160437c08aa9fcdf42` (consensus implementation) |
| 21,836,486 | `addNewRollupType` on RollupManager proxy `0x879f5504acdaa8529618be136b3672be583ebb93` |
| 21,836,487 | `createNewRollup` on the same RollupManager |
| 21,836,488 / 489 | creates `0x796dedb5…`, `0xc8988276…` (data committee) |
| 21,836,490 / 495 / 515 | `setDataAvailabilityProtocol`, `setTrustedSequencerURL` on rollup `0x91d3af7a…`, `setupCommittee` on `0xc8988276…` |
| 21,836,525 | `bridgeAsset` (amount 0, destination network 7) on bridge proxy `0x0a3014e1d323517e3895f4db75757f2c7781d0e6` |

## Reads (eth.drpc.org, block 26,431,595)

- RollupManager `0x879f…bb93`: `rollupCount()` = 1, `rollupTypeCount()` = 1; `rollupTypeMap(1)` = consensus
  `0x3894…df42`, verifier `0xd941fb73…`, forkID 12; `rollupIDToRollupData(1)` = rollup `0x91d3af7a…f0343`, chainID
  762419583, verifier `0xd941fb73…`, forkID 12, lastBatchSequenced 1278, lastVerifiedBatch 1278.
- RollupManager and bridge EIP-1967 admin: ProxyAdmin `0xf1f78417795565b7d710c7f3f8a203f586d5e12f`, `owner()` =
  PolygonZkEVMTimelock `0x3dedc8fa…f62e`; timelock `getMinDelay()` = 60; `hasRole(PROPOSER_ROLE, 0xf91b53b5…)` = true.
- RollupManager roles: timelock holds ADD_ROLLUP_TYPE_ROLE and UPDATE_ROLLUP_ROLE; the deployer EOA holds
  ADD_ROLLUP_TYPE_ROLE; neither holds TRUSTED_AGGREGATOR_ROLE.
- Polygon's shared AgglayerManager `0x5132…7ab2` does not list `0xd941fb73…` in any of its 14 rollup types
  (`evidence/polygon-fflonk-verifier/escrow.json`).

## Holdings (Blockscout, 2026-11-17)

Bridge `0x0a3014e1…` : 0 ETH; 9.499 AIRAS (`0x0624069497f830bea84bd7ad410b878270130035`, no price); RollupManager and
rollup contract: nothing.

## Identity

Chain ID 762419583 is not in chainid.network's list. The only asset in the bridge is the AIRAS token, and L2BEAT
lists an archived project "AIRAS" (search result for l2beat.com/scaling/projects/airas; the page itself returned
404 when fetched). No direct link from the AIRAS token creator `0xa038df4f…` to the deployer was found. Not
attributed.

## Trace

`data/agg/alltime_caller.parquet`: `0xd941fb73…` ecpairing 429 calls, blocks 21,836,729–22,217,151 (last 2025-04-07);
none since in `activity.json`.
