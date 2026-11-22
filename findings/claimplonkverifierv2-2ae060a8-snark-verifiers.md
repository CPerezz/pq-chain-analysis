---
id: claimplonkverifierv2-2ae060a8-snark-verifiers
format: 2
title: INTMAX ITX claim verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: A forged pairing proof passes this verifier; INTMAX's admin can repoint the minter to a post-quantum
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2ae060a830f2f6c7c1cc7d87ea7de4a8bfc707cd'
  name: ClaimPlonkVerifierV2
  project: intmax
  code: verified
  code_url: https://etherscan.io/address/0x2ae060a830f2f6c7c1cc7d87ea7de4a8bfc707cd#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Build a post-quantum claim verifier and have the admin Safe repoint MinterV1V3 to it.
evidence_level: source
checks:
- id: c1
  source: '0x2ae060a830f2f6c7c1cc7d87ea7de4a8bfc707cd'
  file: contracts/verifiers/ClaimPlonkVerifierV2.sol
  line: 837
  has: let check_staticcall := staticcall(gas(), 7, folded_evals_commit, 0x60, folded_evals_commit, 0x40)
  says: Folding uses the BN254 scalar-multiplication precompile on the SRS point.
  for:
  - evidence-2
  - what
- id: c2
  source: '0x2ae060a830f2f6c7c1cc7d87ea7de4a8bfc707cd'
  file: contracts/verifiers/ClaimPlonkVerifierV2.sol
  line: 886
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: The final KZG check is a BN254 pairing precompile call.
  for:
  - action
  - evidence-1
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
  who: review (Review01)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract verifies PLONK proofs for INTMAX ITX claims using a KZG pairing check on BN254. A quantum attacker who recovers the setup trapdoor can make a false claim proof pass here.

## Evidence

- [check_pairing_kzg](https://etherscan.io/address/0x2ae060a830f2f6c7c1cc7d87ea7de4a8bfc707cd#code) decides the proof with the BN254 pairing precompile.
- [batch_verify_multi_points](https://etherscan.io/address/0x2ae060a830f2f6c7c1cc7d87ea7de4a8bfc707cd#code) folds openings against the SRS point with BN254 scalar multiplication.

## Reviewer notes

### Mechanism

Verify (line 178) runs the gnark PLONK checks. batch_verify_multi_points multiplies the SRS G1 point via precompile 7 (line 837), folds digests and quotients with point_add/point_acc_mul (lines 1218, 1280-1283), then check_pairing_kzg calls the pairing precompile 8 at line 886 and ANDs the result into STATE_SUCCESS. Whoever knows the KZG SRS trapdoor (computable from public SRS points with a quantum computer) can open commitments to any value, so any statement verifies. Per kev, MinterV1V3.claimTokens relies on this verifier to release ITX to claimed recipients.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: This contract is not upgradeable and holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
