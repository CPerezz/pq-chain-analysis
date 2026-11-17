---
id: aztec-validator-bls-pop-bn254
title: "Aztec GSE: a quantum attacker can forge the BN254 BLS proof of possession at validator registration, which only reserves a BLS public key; nothing on L1 verifies BLS signatures and no funds move through it"
project: aztec
status: confirmed
severity: LOW
patterns: [PQ-6]
primitives: [bn254, sw_bn254]
trigger: committee-keys
impact: none
alternative: sole
role: auxiliary
contracts:
- address: "0x656f9140b9e2d3769d47b575512d46039dcab4d3"
  implementation: null
  name: Bn254LibWrapper (created by GSE 0xa92ecfd0 in its constructor)
  upgradeable: "no"
  admin: none; fixed as BN254_LIB_WRAPPER (immutable) in GSE 0xa92ecfd0e70c9cd5e5cd76c50af0f7da93567a4f, owned by Governance 0x1102471eb3378fee427121c9efcea452e4b6b75e (can only set the call's gas limit)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 192
families: []
fix:
  layer: new-deployment
  who_acts: Aztec Governance 0x1102471eb3378fee427121c9efcea452e4b6b75e, when it deploys a new GSE with post-quantum validator keys; nothing needed while BLS keys are unused on L1
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/aztec-validator-bls-pop-bn254/classification.jsonl
  - evidence/aztec-validator-bls-pop-bn254/onchain.json
  - evidence/aztec-validator-bls-pop-bn254/activity.json
  - evidence/aztec-validator-bls-pop-bn254/source-excerpts.md
  - evidence/aztec-validator-bls-pop-bn254/aztec-system.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review00 (GSE and rollup v3 source read for every use of the BLS keys; creator and owner reads)
  ref: evidence/aztec-validator-bls-pop-bn254/aztec-system.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [aztec-committee-attestations]
---

## Summary

When a validator stakes on Aztec, the GSE checks a BLS proof of possession for the validator's BN254 public key with
a pairing (`Bn254LibWrapper.proofOfPossession`) and stores the key. A quantum attacker can recover any BLS secret
key from its public key, so it can produce this proof for any key, but the check only gates which BLS key a
staker may register: the stake itself is still required, attestations on L1 are ECDSA, and no L1 contract verifies
a BLS signature with the stored keys. The worst case is registering someone else's public key first so that their
registration with it fails. Rated LOW (step 4: an auxiliary check through which nothing can be taken).

## Mechanism

- `Rollup.deposit` → `StakingLib` queue → `GSE.deposit` → `_checkProofOfPossession` (GSE `GSE.sol` lines 622–650):
  rejects a G1 key already seen (`ownedPKs`, line 640) and calls
  `BN254_LIB_WRAPPER.proofOfPossession{gas: proofOfPossessionGasLimit}(pk1, pk2, pop)` (line 646);
  `BN254Lib.proofOfPossession` checks `e(L, -G2) · e(R, pk2) == 1` with hash-to-point under the domain
  `AZTEC_BLS_POP_BN254_V1` (`BN254Lib.sol` lines 45, 97–101, pairing at 163–198).
- The G1 key is stored in `configOf[attester]` and exposed by `getG1PublicKeysFromAddresses`;
  in the GSE, rollup v3 and their libraries nothing else reads it or calls a pairing (checked in the v3 source tree).
- Pattern PQ-6 (the BLS key scheme), here limited to registration. Excerpts:
  [`source-excerpts.md`](../evidence/aztec-validator-bls-pop-bn254/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify for `0x656f9140…` and the version 0 rollup tree; Blockscout for rollup v3):
  the path above; `Bn254LibWrapper` is created in the GSE constructor (`new Bn254LibWrapper()`, `GSE.sol` line 178).
- CHECKED (Blockscout): creator of `0x656f9140…` is GSE `0xa92ecfd0…`, in the GSE's deployment transaction.
- CHECKED (`eth_call`, block 26,431,459): GSE `owner()` = Governance `0x1102471e…`; GSE `getLatestRollup()` = Rollup
  v3 `0xe37a2663…`; the wrapper holds nothing
  ([`aztec-system.json`](../evidence/aztec-validator-bls-pop-bn254/aztec-system.json)).
- CHECKED (Xatu, any function): 192 transactions called the wrapper in 2026-10-16 to 2026-11-16 (validator
  registrations), last on 2026-11-15 ([`activity.json`](../evidence/aztec-validator-bls-pop-bn254/activity.json)).
- INFERRED: the keys are collected for future BLS aggregation of attestations; if a later rollup version verifies
  aggregate BLS attestations on L1, that becomes a PQ-6 committee finding with the escrow of
  [aztec-committee-attestations](aztec-committee-attestations.md).

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x656f9140…` Bn254LibWrapper | no | none (registration check) | 2026-11-15 | 192 |

The check moves no value: deposits still need 200,000 AZTEC per validator (`getActivationThreshold()`), and the
validator stake (618.9M AZTEC in Governance through the GSE) is withdrawn by the withdrawer address, not by the BLS
key. Post-quantum validators are not locked out: any validator can generate a BN254 key to register.

## Remediation

- None needed while BLS keys are not verified on L1. Before a rollup version verifies aggregate BLS attestations,
  Aztec Governance `0x1102471eb3378fee427121c9efcea452e4b6b75e` should instead adopt post-quantum validator keys
  (hash-based or lattice signatures aggregated in a STARK proof), which needs a new GSE because the wrapper is
  immutable in the current one.
- No Ethereum protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated CRITICAL (step 4: pooled funds released by a forged proof or attestation, and the verification cannot change).
- 2026-11-17 review (Review00): CRITICAL -> LOW, step 4: the pairing only checks a proof of possession at
  registration; no L1 contract verifies BLS signatures with the keys, attestations are ECDSA, and nothing can be
  taken. `impact` funds-loss -> none, `role` core -> auxiliary; owner traced (wrapper immutable inside GSE
  `0xa92ecfd0…`, owned by Governance).
