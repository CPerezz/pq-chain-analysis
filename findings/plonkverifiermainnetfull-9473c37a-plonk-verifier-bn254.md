---
id: plonkverifiermainnetfull-9473c37a-plonk-verifier-bn254
format: 2
title: Linea PLONK verifier accepts BN254 KZG proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Setup trapdoor lets false proofs pass; Linea's Security Council fixes it by setting a post-quantum
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9473c37a9fe76fbbc3fd7d3b59e1b550415bd873'
  name: PlonkVerifierMainnetFull
  project: linea
  code: verified
  code_url: https://etherscan.io/address/0x9473c37a9fe76fbbc3fd7d3b59e1b550415bd873#code
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
  source: '0x9473c37a9fe76fbbc3fd7d3b59e1b550415bd873'
  file: src/verifiers/PlonkVerifierMainnetFull.sol
  line: 847
  has: let check_staticcall := staticcall(gas(), 7, folded_evals_commit, 0x60, folded_evals_commit, 0x40)
  says: The folded evaluations are committed with ecMul on the G1 setup point.
  for:
  - evidence-2
- id: c2
  source: '0x9473c37a9fe76fbbc3fd7d3b59e1b550415bd873'
  file: src/verifiers/PlonkVerifierMainnetFull.sol
  line: 896
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: Proof validity is decided by the BN254 pairing precompile.
  for:
  - evidence-1
  - justification
  - what
- id: srs-g2
  source: '0x9473c37a9fe76fbbc3fd7d3b59e1b550415bd873'
  file: src/verifiers/PlonkVerifierMainnetFull.sol
  has: G2_SRS_0_X_0) // the 4 lines are the canonical G2 point on BN254
  line: 876
  says: The pairing check uses fixed G2 setup points on BN254.
  for:
  - evidence-2
  - justification
  - what
- id: srs-g1
  source: '0x9473c37a9fe76fbbc3fd7d3b59e1b550415bd873'
  file: src/verifiers/PlonkVerifierMainnetFull.sol
  has: mstore(folded_evals_commit, G1_SRS_X)
  line: 844
  says: The KZG check uses the fixed G1 setup point.
  for:
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

This contract verifies gnark PLONK proofs for Linea and accepts one when a KZG pairing check over BN254 against fixed setup points succeeds. A quantum attacker who recovers the setup trapdoor can build a false proof that passes this check.

## Evidence

- [check_pairing_kzg](https://etherscan.io/address/0x9473c37a9fe76fbbc3fd7d3b59e1b550415bd873#code) decides validity with the BN254 pairing precompile (0x08).
- [batch_verify_multi_points](https://etherscan.io/address/0x9473c37a9fe76fbbc3fd7d3b59e1b550415bd873#code) pairs proof points with fixed G2 setup points on BN254.

## Reviewer notes

### Mechanism

batch_verify_multi_points (lines 808-887) folds the proof's opening commitments with a SHA2-derived random scalar, multiplies the G1 setup point G1_SRS (line 844) by the folded evaluations via ecMul (line 847, precompile 7), combines with the folded digests and quotients via point_acc_mul_calldata (lines 1309-1320, ecMul/ecAdd), then loads the G2 setup points G2_SRS_0 and G2_SRS_1 (lines 876-885) and calls check_pairing_kzg, whose staticcall to precompile 8 (line 896) stores the pairing result as STATE_SUCCESS. Soundness rests on the KZG trusted setup; knowing the trapdoor (a discrete log on BN254, recoverable by a quantum computer) lets a prover open commitments to any value and pass this check.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy or admin read; the contract holds about $0.
- Ruled out: No calls in the study's 30-day window.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
