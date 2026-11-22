---
id: plonkverifiermainnetfull-8f8ec960-plonk-verifier-bn254
format: 2
title: Linea PLONK verifier accepts BN254 KZG proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Proofs hinge on a BN254 pairing over a KZG setup; Linea's Security Council fixes it by setting a
  post-quantum verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8f8ec9608223c0b8d13238950c03f5d42ceebb9b'
  name: PlonkVerifierMainnetFull
  project: linea
  code: verified
  code_url: https://etherscan.io/address/0x8f8ec9608223c0b8d13238950c03f5d42ceebb9b#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a hash-based (STARK/FRI) verifier and set it for each proofType in use.
evidence_level: source
checks:
- id: c1
  source: '0x8f8ec9608223c0b8d13238950c03f5d42ceebb9b'
  file: src/verifiers/osaka/PlonkVerifierMainnetFull.sol
  line: 852
  has: let check_staticcall := staticcall(gas(), 7, folded_evals_commit, 0x60, folded_evals_commit, 0x40)
  says: The folded evaluations are committed with ecMul against the setup's G1 point.
  for:
  - evidence-2
- id: c2
  source: '0x8f8ec9608223c0b8d13238950c03f5d42ceebb9b'
  file: src/verifiers/osaka/PlonkVerifierMainnetFull.sol
  line: 901
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: The final check is a BN254 pairing precompile call.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: srs
  source: '0x8f8ec9608223c0b8d13238950c03f5d42ceebb9b'
  file: src/verifiers/osaka/PlonkVerifierMainnetFull.sol
  has: mstore(add(mPtr, 0x100), G2_SRS_1_X_0)
  line: 887
  says: The pairing input uses the KZG setup's G2 point.
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

This verifier checks Linea PLONK proofs by ending in a BN254 pairing check against fixed KZG setup points. A quantum attacker who recovers the setup trapdoor can build proofs that pass this check for false statements.

## Evidence

- [check_pairing_kzg](https://etherscan.io/address/0x8f8ec9608223c0b8d13238950c03f5d42ceebb9b#code) calls the BN254 pairing precompile (0x08) on the batched KZG opening.
- [batch_verify_multi_points](https://etherscan.io/address/0x8f8ec9608223c0b8d13238950c03f5d42ceebb9b#code) pairs the folded proof against the setup's G2 points.

## Reviewer notes

### Mechanism

batch_verify_multi_points (lines ~813-891) derives a random challenge with SHA2, folds the quotients and digests with point_acc_mul_calldata (ecMul precompile 7, line 1304), commits the folded evaluations against G1_SRS (line 852), then builds a pairing input with the setup's G2_SRS_0 and G2_SRS_1 points (lines 881-890). check_pairing_kzg (line 901) calls precompile 8 and stores the result as STATE_SUCCESS. Soundness rests on the KZG setup trapdoor staying unknown; discrete logs on BN254 give it to a quantum attacker, who can then open commitments to any value and forge proofs. In kev's finding this build was formerly set in LineaRollup; the current verifiers are newer builds of the same design.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds and has no admin or proxy.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
