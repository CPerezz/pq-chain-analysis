---
id: unidentified-d941fb73-snark-verifier
title: "Standalone Polygon CDK validium (chain 762419583): a forged fflonk proof could finalize false state on its own RollupManager, whose bridge holds nothing priced; dormant since 2025-04"
project: unidentified-d941fb73
status: confirmed
severity: LOW
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
  links:
  - evidence/unidentified-d941fb73-snark-verifier/classification.jsonl
  - evidence/unidentified-d941fb73-snark-verifier/onchain.json
  - evidence/unidentified-d941fb73-snark-verifier/activity.json
  - evidence/unidentified-d941fb73-snark-verifier/source-excerpts.md
  - evidence/unidentified-d941fb73-snark-verifier/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review14 (deployer history, RollupManager and bridge reads)
  ref: evidence/unidentified-d941fb73-snark-verifier/notes.md
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
  final BN254 `ecpairing` against the fflonk SRS ([`source-excerpts.md`](../evidence/unidentified-d941fb73-snark-verifier/source-excerpts.md)).
- Pattern PQ-7.

## Evidence

- CHECKED (Sourcify verified source): FflonkVerifier_12 pairing check (excerpt).
- CHECKED (Blockscout, deployer `0xf91b…649e` transactions): on 2025-02-13 it created this verifier, called
  `addNewRollupType` and `createNewRollup` on RollupManager `0x879f…bb93`, set the data-availability protocol and data
  committee, and made a zero-value `bridgeAsset` on bridge `0x0a30…d0e6` ([`notes.md`](../evidence/unidentified-d941fb73-snark-verifier/notes.md)).
- CHECKED (cast via eth.drpc.org at block 26,431,595): `rollupCount()` = 1, `rollupTypeMap(1)` and
  `rollupIDToRollupData(1)` point to `0xd941fb73…`; last sequenced and verified batch 1278; ProxyAdmin
  `0xf1f7…e12f` owned by PolygonZkEVMTimelock `0x3ded…f62e` (`getMinDelay()` = 60, proposer = the deployer EOA).
- CHECKED (cast): Polygon's AgglayerManager `0x5132…7ab2` does not use this verifier in any of its 14 rollup types, so
  this contract does not belong in `polygon-fflonk-verifier`.
- CHECKED (precompile trace): 429 pairing calls, blocks 21,836,729–22,217,151 (last 2025-04-07); no calls since
  ([`activity.json`](../evidence/unidentified-d941fb73-snark-verifier/activity.json)).
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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-04-07) and nothing held).
- 2026-11-17 review (Review14): LOW kept, step 1. Consumer identified as a standalone CDK validium (own RollupManager `0x879f…bb93`, chain ID 762419583), not Polygon's Agglayer; project still unidentified (possibly AIRAS). Escrow measured: nothing priced.
