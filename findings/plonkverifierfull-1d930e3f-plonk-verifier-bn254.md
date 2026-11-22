---
id: plonkverifierfull-1d930e3f-plonk-verifier-bn254
format: 2
title: Linea proofType-1 verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: KZG pairing check over BN254 falls to a quantum attacker; the Security Council can point proofType
  1 at a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1d930e3fac9fbc7026ec17962d2f57d558d37532'
  name: PlonkVerifierFull
  project: linea
  code: verified
  code_url: https://etherscan.io/address/0x1d930e3fac9fbc7026ec17962d2f57d558d37532#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 309
impact: funds-loss
action: Deploy a hash-based (STARK/FRI) verifier and have the Security Council set it for proofType 1 via setVerifierAddress.
evidence_level: source
checks:
- id: c1
  source: '0x1d930e3fac9fbc7026ec17962d2f57d558d37532'
  file: src/verifiers/PlonkVerifierFull.sol
  line: 865
  has: let check_staticcall := staticcall(gas(), 7, folded_evals_commit, 0x60, folded_evals_commit, 0x40)
  says: Opening fold uses BN254 scalar multiplication precompile 7.
  for:
  - evidence-2
  - what
- id: c2
  source: '0x1d930e3fac9fbc7026ec17962d2f57d558d37532'
  file: src/verifiers/PlonkVerifierFull.sol
  line: 914
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: Final KZG check calls the BN254 pairing precompile 8.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x1d930e3fac9fbc7026ec17962d2f57d558d37532'
  file: src/verifiers/PlonkVerifierFull.sol
  line: 1331
  has: let l_success := staticcall(gas(), 7, mPtr, 0x60, mPtr, 0x40)
  says: Proof points are combined with BN254 scalar multiplication.
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

This contract verifies gnark PLONK proofs for LineaRollup's proofType 1 and accepts a proof when a KZG pairing check on BN254 passes. With the setup trapdoor recovered by a quantum computer, an attacker could build a proof for a false state that this check accepts.

## Evidence

- [check_pairing_kzg](https://etherscan.io/address/0x1d930e3fac9fbc7026ec17962d2f57d558d37532#code) ends verification with a pairing call to precompile 8 (BN254).
- [batch_verify_multi_points](https://etherscan.io/address/0x1d930e3fac9fbc7026ec17962d2f57d558d37532#code) folds openings with BN254 scalar multiplication at precompile 7.

## Reviewer notes

### Mechanism

LineaRollup.finalizeBlocks reads verifiers[proofType] and calls Verify(proof, [publicInput]); this contract is verifiers(1) per kev's read. Verify folds the commitments with BN254 EC mul/add (point_acc_mul_calldata, line 1331; batch_verify_multi_points, line 865) and finishes in check_pairing_kzg (line 914), a staticcall to the BN254 pairing precompile 8 against the G2 SRS points (lines 894-903). Soundness rests on the KZG setup trapdoor staying secret; a quantum computer recovering it from the SRS points lets an attacker, also holding an operator EOA key, forge a proof for a false state root and false L2 messages, then claim ETH from LineaRollup and tokens from the TokenBridge. Fix: Security Council Safe through the TimeLock (VERIFIER_SETTER_ROLE) sets a post-quantum verifier.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable and holds no funds itself.
- Ruled out: Use of proofType 1 in finalizations was not measured.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
