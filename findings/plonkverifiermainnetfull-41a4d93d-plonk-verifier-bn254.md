---
id: plonkverifiermainnetfull-41a4d93d-plonk-verifier-bn254
format: 2
title: Retired Linea PLONK verifier accepts BN254 proofs a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: Soundness rests on a BN254 KZG setup; Linea's Security Council fixes it by setting a post-quantum
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x41a4d93d09f4718fe899d12a4ad2c8a09104bdc7'
  name: PlonkVerifierMainnetFull
  project: linea
  code: verified
  code_url: https://etherscan.io/address/0x41a4d93d09f4718fe899d12a4ad2c8a09104bdc7#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Keep this verifier unset and point each LineaRollup proofType at a hash-based post-quantum verifier.
evidence_level: source
checks:
- id: c1
  source: '0x41a4d93d09f4718fe899d12a4ad2c8a09104bdc7'
  file: src/verifiers/PlonkVerifierMainnetFull.sol
  line: 847
  has: let check_staticcall := staticcall(gas(), 7, folded_evals_commit, 0x60, folded_evals_commit, 0x40)
  says: The G1 setup point is multiplied with the BN254 ecMul precompile.
  for:
  - evidence-3
- id: c2
  source: '0x41a4d93d09f4718fe899d12a4ad2c8a09104bdc7'
  file: src/verifiers/PlonkVerifierMainnetFull.sol
  line: 896
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: The final KZG check calls the BN254 pairing precompile.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: g2-bn254
  source: '0x41a4d93d09f4718fe899d12a4ad2c8a09104bdc7'
  file: src/verifiers/PlonkVerifierMainnetFull.sol
  has: the 4 lines are the canonical G2 point on BN254
  line: 876
  says: The pairing uses the canonical BN254 G2 setup point.
  for:
  - evidence-2
  - justification
  - what
- id: g1-srs
  source: '0x41a4d93d09f4718fe899d12a4ad2c8a09104bdc7'
  file: src/verifiers/PlonkVerifierMainnetFull.sol
  has: mstore(folded_evals_commit, G1_SRS_X)
  line: 844
  says: Verification uses a fixed G1 setup point from the trusted setup.
  for:
  - evidence-3
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

This contract verifies Linea PLONK proofs over BN254 and accepts a proof only if a final KZG pairing check against fixed setup points passes. A quantum attacker who recovers the setup trapdoor can build proofs it accepts for false statements.

## Evidence

- [check_pairing_kzg](https://etherscan.io/address/0x41a4d93d09f4718fe899d12a4ad2c8a09104bdc7#code) runs the final pairing check through the BN254 pairing precompile.
- [batch_verify_multi_points](https://etherscan.io/address/0x41a4d93d09f4718fe899d12a4ad2c8a09104bdc7#code) pairs the folded proof against the canonical BN254 G2 setup point.
- [batch_verify_multi_points](https://etherscan.io/address/0x41a4d93d09f4718fe899d12a4ad2c8a09104bdc7#code) multiplies the fixed G1 setup point through the BN254 scalar-multiplication precompile.

## Reviewer notes

### Mechanism

batch_verify_multi_points derives a random challenge with SHA2 (line 824). It folds the quotient openings and digests with point_acc_mul_calldata, which uses ecMul (precompile 7, line 1313) and ecAdd. It multiplies G1_SRS by the folded evaluations (lines 844-847). It then loads the canonical BN254 G2 point and G2_SRS_1 (lines 876-885). check_pairing_kzg calls the pairing precompile 8 (line 896) and stores the result as STATE_SUCCESS. Soundness depends on the secret tau behind G2_SRS_1/G1_SRS staying unknown. A party who learns the trapdoor (for example via discrete log on BN254 with a quantum computer) can forge KZG openings and so forge PLONK proofs that pass this check.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract is not upgradeable and holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
