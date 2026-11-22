---
id: plonkverifiermainnetfull-a12e79c3-plonk-verifier-bn254
format: 2
title: Retired Linea PLONK verifier trusts a BN254 setup a quantum attacker can break
status: confirmed
severity: MEDIUM
justification: Soundness rests on BN254 KZG pairings; the fix is a config change that points LineaRollup at a post-quantum
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa12e79c375fb0aaddfda597bbe7b4e9a92e9b3de'
  name: PlonkVerifierMainnetFull
  project: linea
  code: verified
  code_url: https://etherscan.io/address/0xa12e79c375fb0aaddfda597bbe7b4e9a92e9b3de#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
evidence_level: source
checks:
- id: c1
  source: '0xa12e79c375fb0aaddfda597bbe7b4e9a92e9b3de'
  file: src/verifiers/prague/PlonkVerifierMainnetFull.sol
  line: 852
  has: let check_staticcall := staticcall(gas(), 7, folded_evals_commit, 0x60, folded_evals_commit, 0x40)
  says: Scalar multiplication of the setup G1 point uses the BN254 precompile 0x07.
  for:
  - evidence-3
  - justification
  - what
- id: c2
  source: '0xa12e79c375fb0aaddfda597bbe7b4e9a92e9b3de'
  file: src/verifiers/prague/PlonkVerifierMainnetFull.sol
  line: 901
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: The final KZG check calls the BN254 pairing precompile 0x08.
  for:
  - evidence-1
  - justification
  - what
- id: g2srs
  source: '0xa12e79c375fb0aaddfda597bbe7b4e9a92e9b3de'
  file: src/verifiers/prague/PlonkVerifierMainnetFull.sol
  has: mstore(add(mPtr, 0x100), G2_SRS_1_X_0)
  line: 887
  says: The pairing input uses the trusted setup's G2 point [x].
  for:
  - evidence-2
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

This contract verifies gnark PLONK proofs. It accepts a proof when a final KZG pairing check over BN254 passes against the trusted setup's committed points. A quantum attacker who recovers the setup trapdoor can build a false proof that passes this check.

## Evidence

- [check_pairing_kzg](https://etherscan.io/address/0xa12e79c375fb0aaddfda597bbe7b4e9a92e9b3de#code) runs the BN254 pairing precompile (0x08) on the folded KZG opening.
- [batch_verify_multi_points](https://etherscan.io/address/0xa12e79c375fb0aaddfda597bbe7b4e9a92e9b3de#code) pairs the proof against the setup's G2 points.
- [batch_verify_multi_points](https://etherscan.io/address/0xa12e79c375fb0aaddfda597bbe7b4e9a92e9b3de#code) multiplies the setup's G1 point with the BN254 scalar-multiplication precompile (0x07).

## Reviewer notes

### Mechanism

batch_verify_multi_points (lines 813-891) folds the digests and opening proofs using a SHA2-derived random scalar (line 829). It multiplies G1_SRS by the folded evaluations with precompile 7 (line 852) and accumulates points via point_acc_mul_calldata (line 1304). It then builds a two-pair pairing input using G2_SRS_0 and G2_SRS_1 (lines 881-890). check_pairing_kzg calls precompile 8 (line 901) and stores the result as STATE_SUCCESS. Soundness depends on the secret behind G2_SRS_1, the KZG setup trapdoor, staying unknown. Discrete logs on BN254 fall to a quantum computer. With the trapdoor, an attacker can open commitments to arbitrary values, so a false proof passes. This build is a former LineaRollup verifier, now replaced.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no funds and is not upgradeable.
- Ruled out: No longer set as a LineaRollup verifier; it gates no current finalization.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
