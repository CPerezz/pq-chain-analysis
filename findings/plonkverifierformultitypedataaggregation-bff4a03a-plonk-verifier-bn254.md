---
id: plonkverifierformultitypedataaggregation-bff4a03a-plonk-verifier-bn254
format: 2
title: Linea PLONK verifier trusts a BN254 KZG setup a quantum attacker could break
status: confirmed
severity: MEDIUM
justification: Setup trapdoor lets forged proofs pass; the Security Council fixes it by setting a post-quantum verifier
  on LineaRollup.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbff4a03a355eef7da720bbc7878f9bdbbe81fe6f'
  name: PlonkVerifierForMultiTypeDataAggregation
  project: linea
  code: verified
  code_url: https://etherscan.io/address/0xbff4a03a355eef7da720bbc7878f9bdbbe81fe6f#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace this BN254 KZG verifier with a hash-based verifier before LineaRollup points any proof type at it.
evidence_level: source
checks:
- id: c1
  source: '0xbff4a03a355eef7da720bbc7878f9bdbbe81fe6f'
  file: contracts/verifiers/PlonkVerifierForMultiTypeDataAggregation.sol
  line: 845
  has: let check_staticcall := staticcall(gas(), 7, folded_evals_commit, 0x60, folded_evals_commit, 0x40)
  says: Scalar multiplication of the setup G1 point via BN254 precompile 7.
  for:
  - evidence-2
  - justification
  - what
- id: c2
  source: '0xbff4a03a355eef7da720bbc7878f9bdbbe81fe6f'
  file: contracts/verifiers/PlonkVerifierForMultiTypeDataAggregation.sol
  line: 894
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: Final KZG check uses the BN254 pairing precompile 8.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c7
  source: '0xbff4a03a355eef7da720bbc7878f9bdbbe81fe6f'
  file: contracts/verifiers/PlonkVerifierForMultiTypeDataAggregation.sol
  line: 1309
  has: let l_success := staticcall(gas(), 7, mPtr, 0x60, mPtr, 0x40)
  says: Point multiplication via BN254 precompile 7.
  for:
  - evidence-3
- id: c8
  source: '0xbff4a03a355eef7da720bbc7878f9bdbbe81fe6f'
  file: contracts/verifiers/PlonkVerifierForMultiTypeDataAggregation.sol
  line: 1312
  has: l_success := and(l_success, staticcall(gas(), 6, mPtr, 0x80, dst, 0x40))
  says: Point addition via BN254 precompile 6.
  for:
  - evidence-3
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

This contract checks Linea PLONK proofs over BN254 and ends in a KZG pairing check against fixed setup points. With the setup trapdoor recovered by a quantum computer, an attacker can build a proof for a false statement that passes this check.

## Evidence

- [check_pairing_kzg](https://etherscan.io/address/0xbff4a03a355eef7da720bbc7878f9bdbbe81fe6f#code) runs the final KZG check through the BN254 pairing precompile.
- [batch_verify_multi_points](https://etherscan.io/address/0xbff4a03a355eef7da720bbc7878f9bdbbe81fe6f#code) multiplies the setup's G1 point with the BN254 scalar-multiplication precompile.
- [point_acc_mul](https://etherscan.io/address/0xbff4a03a355eef7da720bbc7878f9bdbbe81fe6f#code) folds commitments with the BN254 add and multiply precompiles.

## Reviewer notes

### Mechanism

batch_verify_multi_points (lines 806-884) derives a random value with sha256 over the folded digests and openings. It folds the quotients and digests with point_acc_mul_calldata. It computes [folded_evals]G1_SRS with precompile 7 (line 845) and negates it. It adds the point openings and loads the G2_SRS_0 and G2_SRS_1 setup points (lines 873-882). It then calls check_pairing_kzg, which runs precompile 8 (line 894) and ANDs the result into STATE_SUCCESS. The helpers point_add and point_mul (lines 1247, 1278) and point_acc_mul (lines 1309, 1312) use BN254 precompiles 6 and 7. Soundness rests on nobody knowing the KZG setup trapdoor; a discrete-log break on BN254 reveals it and allows forged proofs. In kev's finding, LineaRollup.finalizeBlocks trusts verifiers[proofType] to finalize state, so the fix is a new verifier set by the Security Council through the TimeLock.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: This contract holds no funds itself.
- Ruled out: Not upgradeable; no admin read.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
