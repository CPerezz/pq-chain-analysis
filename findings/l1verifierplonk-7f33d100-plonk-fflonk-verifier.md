---
id: l1verifierplonk-7f33d100-plonk-fflonk-verifier
format: 2
title: ZKsync PLONK verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Proofs rest on BN254 pairings; ZKsync governance can swap in a new verifier via upgrade, hence MEDIUM.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7f33d100f482093182111d69a4a457289e99f4ec'
  name: L1VerifierPlonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x7f33d100f482093182111d69a4a457289e99f4ec#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3
impact: funds-loss
action: Replace the BN254 PLONK wrapper with a post-quantum STARK/FRI verifier and repoint chains via a protocol
  upgrade.
evidence_level: source
checks:
- id: c1
  source: '0x7f33d100f482093182111d69a4a457289e99f4ec'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 394
  has: if iszero(staticcall(gas(), 7, 0, 0x60, dest, 0x40)) {
  says: ecMul precompile used in pointMulIntoDest
  for:
  - what
- id: c2
  source: '0x7f33d100f482093182111d69a4a457289e99f4ec'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 405
  has: if iszero(staticcall(gas(), 6, 0x00, 0x80, dest, 0x40)) {
  says: ecAdd precompile used in pointAddIntoDest
  for:
  - what
- id: c5
  source: '0x7f33d100f482093182111d69a4a457289e99f4ec'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 437
  has: let success := staticcall(gas(), 7, 0, 0x60, 0, 0x40)
  says: ecMul in pointMulAndAddIntoDest
  for:
  - evidence-2
- id: c6
  source: '0x7f33d100f482093182111d69a4a457289e99f4ec'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 441
  has: success := and(success, staticcall(gas(), 6, 0x00, 0x80, dest, 0x40))
  says: ecAdd in pointMulAndAddIntoDest
  for:
  - evidence-2
- id: c7
  source: '0x7f33d100f482093182111d69a4a457289e99f4ec'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 1673
  has: let success := staticcall(gas(), 8, 0, 0x180, 0x00, 0x20)
  says: final BN254 pairing precompile call decides acceptance
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
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract checks ZK Stack batch PLONK proofs using BN254 point additions, multiplications and a final pairing. With the setup trapdoor a quantum attacker can build a false proof that passes the pairing check.

## Evidence

- [finalPairing](https://etherscan.io/address/0x7f33d100f482093182111d69a4a457289e99f4ec#code) accepts the proof only if the BN254 pairing precompile returns true.
- [pointMulAndAddIntoDest](https://etherscan.io/address/0x7f33d100f482093182111d69a4a457289e99f4ec#code) aggregates commitments with the ecMul and ecAdd precompiles.

## Reviewer notes

### Mechanism

Verification runs loadProof, initializeTranscript, verifyQuotientEvaluation, prepareQueries, prepareAggregatedCommitment and finalPairing (lines 1688-1703). Commitments are combined with ecMul (precompile 7, line 394/437) and ecAdd (precompile 6, lines 405-441). finalPairing calls the pairing precompile 8 at line 1673 and reverts unless it returns true; otherwise the function returns true (1705). Soundness depends on the BN254 KZG setup, whose trapdoor a quantum attacker can recover to forge proofs.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable and has no admin.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
