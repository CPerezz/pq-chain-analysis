---
id: plonkverifiermainnetfull-814d8078-plonk-verifier-bn254
format: 2
title: Retired Linea BN254 PLONK verifier accepts proofs forged via setup trapdoor
status: confirmed
severity: MEDIUM
justification: Pairing-based KZG check breaks with quantum; rated medium since Linea's Council sets verifiers and
  has retired this one
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x814d80782aa8c508ababe9c6956d8f1f90e5177a'
  name: PlonkVerifierMainnetFull
  project: linea
  code: verified
  code_url: https://etherscan.io/address/0x814d80782aa8c508ababe9c6956d8f1f90e5177a#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Keep this verifier unset and point LineaRollup proof types at a hash-based post-quantum verifier
evidence_level: source
checks:
- id: c1
  source: '0x814d80782aa8c508ababe9c6956d8f1f90e5177a'
  file: src/verifiers/beta-v4.1/PlonkVerifierMainnet.sol
  line: 847
  has: let check_staticcall := staticcall(gas(), 7, folded_evals_commit, 0x60, folded_evals_commit, 0x40)
  says: G1 SRS point multiplied via BN254 EC_MUL precompile 7 in KZG folding
  for:
  - evidence-2
  - what
- id: c2
  source: '0x814d80782aa8c508ababe9c6956d8f1f90e5177a'
  file: src/verifiers/beta-v4.1/PlonkVerifierMainnet.sol
  line: 896
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: final KZG check uses BN254 pairing precompile 8
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x814d80782aa8c508ababe9c6956d8f1f90e5177a'
  file: src/verifiers/beta-v4.1/PlonkVerifierMainnet.sol
  line: 1313
  has: let l_success := staticcall(gas(), 7, mPtr, 0x60, mPtr, 0x40)
  says: proof points folded via BN254 EC_MUL precompile 7
  for:
  - evidence-2
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

This contract is a retired gnark PLONK verifier for Linea rollup proofs, checking them with a KZG pairing over BN254. A quantum attacker who recovers the setup trapdoor can forge proofs it accepts, which matters if LineaRollup points at it again.

## Evidence

- [check_pairing_kzg](https://etherscan.io/address/0x814d80782aa8c508ababe9c6956d8f1f90e5177a#code) decides the proof with the BN254 pairing precompile (0x08).
- [batch_verify_multi_points](https://etherscan.io/address/0x814d80782aa8c508ababe9c6956d8f1f90e5177a#code) folds KZG openings with BN254 scalar multiplication (precompile 0x07).

## Reviewer notes

### Mechanism

batch_verify_multi_points (lines 808-887) derives a random fold challenge, folds quotients and digests with point_acc_mul_calldata (EC_MUL precompile 7 at line 1313, EC_ADD), multiplies the G1 SRS point by folded evaluations (line 847), then sets up the pairing against the G2 SRS points (lines 876-885) and calls check_pairing_kzg, which runs staticcall to precompile 8 (line 896) and stores the result as STATE_SUCCESS. Soundness rests on the KZG trusted setup over BN254; knowledge of the toxic-waste trapdoor, recoverable by a quantum computer from the SRS, lets a prover open commitments to arbitrary values and pass this check.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not currently set in LineaRollup verifiers(0) or verifiers(1); it secures nothing now
- Ruled out: Holds no funds; not upgradeable

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
