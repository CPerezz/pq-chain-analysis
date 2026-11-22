---
id: plonkverifiermainnetfull-ed39c0c4-plonk-verifier-bn254
format: 2
title: Retired Linea verifier checks PLONK proofs on BN254, forgeable by quantum
status: confirmed
severity: MEDIUM
justification: Quantum can recover the BN254 KZG setup trapdoor; the Security Council can fix it by setting a new
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xed39c0c41a7651006953ab58ecb3039363620995'
  name: PlonkVerifierMainnetFull
  project: linea
  code: verified
  code_url: https://etherscan.io/address/0xed39c0c41a7651006953ab58ecb3039363620995#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace this BN254 PLONK verifier with a hash-based verifier before pointing any Linea proof type at it.
evidence_level: source
checks:
- id: c1
  source: '0xed39c0c41a7651006953ab58ecb3039363620995'
  file: src/verifiers/PlonkVerifierMainnetFull.sol
  line: 847
  has: let check_staticcall := staticcall(gas(), 7, folded_evals_commit, 0x60, folded_evals_commit, 0x40)
  says: ecMul (0x07) on the G1 setup point during batch opening.
  for:
  - what
- id: c2
  source: '0xed39c0c41a7651006953ab58ecb3039363620995'
  file: src/verifiers/PlonkVerifierMainnetFull.sol
  line: 896
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: The final KZG pairing check runs through precompile 0x08.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c4
  source: '0xed39c0c41a7651006953ab58ecb3039363620995'
  file: src/verifiers/PlonkVerifierMainnetFull.sol
  line: 1313
  has: let l_success := staticcall(gas(), 7, mPtr, 0x60, mPtr, 0x40)
  says: Proof points are combined with BN254 ecMul (0x07).
  for:
  - evidence-3
- id: srs-g1
  source: '0xed39c0c41a7651006953ab58ecb3039363620995'
  file: src/verifiers/PlonkVerifierMainnetFull.sol
  has: mstore(folded_evals_commit, G1_SRS_X)
  line: 844
  says: The fixed G1 setup point is used in the KZG fold.
  for:
  - evidence-2
  - what
- id: srs-g2
  source: '0xed39c0c41a7651006953ab58ecb3039363620995'
  file: src/verifiers/PlonkVerifierMainnetFull.sol
  has: G2_SRS_0_X_0) // the 4 lines are the canonical G2 point on BN254
  line: 876
  says: The pairing input uses the BN254 G2 setup points.
  for:
  - evidence-2
  - justification
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review12)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract checks Linea's gnark PLONK proofs with a KZG pairing check on BN254 against fixed setup points. With the setup trapdoor, a quantum attacker can build a false proof that this check accepts.

## Evidence

- [check_pairing_kzg](https://etherscan.io/address/0xed39c0c41a7651006953ab58ecb3039363620995#code) decides the proof with the BN254 pairing precompile (0x08).
- [batch_verify_multi_points](https://etherscan.io/address/0xed39c0c41a7651006953ab58ecb3039363620995#code) folds the openings using the fixed G1 and G2 setup points.
- [point_acc_mul_calldata](https://etherscan.io/address/0xed39c0c41a7651006953ab58ecb3039363620995#code) combines proof points with BN254 scalar multiplication (0x07).

## Reviewer notes

### Mechanism

In this verifier, batch_verify_multi_points (lines 808-887) derives a random challenge with SHA2 and reduces it mod R_MOD (line 828). It folds the proof's opening points with point_acc_mul_calldata, which calls ecMul (0x07) at line 1313 and ecAdd. It multiplies G1_SRS by the folded evaluations (lines 844-847). It then pairs the result with G2_SRS_0 and G2_SRS_1 (lines 876-885). check_pairing_kzg runs the pairing precompile 0x08 at line 896 and stores the result as STATE_SUCCESS. Soundness rests on the KZG setup trapdoor staying unknown and on discrete logs in BN254 staying hard. Shor's algorithm breaks both, which allows proofs of false statements. LineaRollup's finalizeBlocks trusted this verifier's Verify result when it was set for a proofType.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Kev's census lists this verifier as retired (no longer set in LineaRollup verifiers); it holds no funds.
- Ruled out: No admin or proxy: the code is fixed.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
