---
id: zksyncosverifierplonk-433fe66e-plonk-fflonk-verifier
format: 2
title: ZKsync OS PLONK verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Pairing-based BN254 proof check falls to a quantum attacker; ZKsync governance can swap the verifier,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x433fe66eeb710a6a0f5c70d4cd2a815a078002b1'
  name: ZKsyncOSVerifierPlonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x433fe66eeb710a6a0f5c70d4cd2a815a078002b1#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1597
impact: funds-loss
action: Replace the BN254 wrapper with a hash-based STARK/FRI verifier and repoint the ZKsync OS dual verifier to
  it.
evidence_level: source
checks:
- id: c1
  source: '0x433fe66eeb710a6a0f5c70d4cd2a815a078002b1'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 394
  has: if iszero(staticcall(gas(), 7, 0, 0x60, dest, 0x40)) {
  says: ecMul precompile used on proof points
  for:
  - what
- id: c2
  source: '0x433fe66eeb710a6a0f5c70d4cd2a815a078002b1'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 405
  has: if iszero(staticcall(gas(), 6, 0x00, 0x80, dest, 0x40)) {
  says: ecAdd precompile used on proof points
  for:
  - what
- id: c5
  source: '0x433fe66eeb710a6a0f5c70d4cd2a815a078002b1'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 437
  has: let success := staticcall(gas(), 7, 0, 0x60, 0, 0x40)
  says: ecMul in pointMulAndAddIntoDest
  for:
  - evidence-2
- id: c6
  source: '0x433fe66eeb710a6a0f5c70d4cd2a815a078002b1'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 441
  has: success := and(success, staticcall(gas(), 6, 0x00, 0x80, dest, 0x40))
  says: ecAdd in pointMulAndAddIntoDest
  for:
  - evidence-2
- id: c7
  source: '0x433fe66eeb710a6a0f5c70d4cd2a815a078002b1'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 1673
  has: let success := staticcall(gas(), 8, 0, 0x180, 0x00, 0x20)
  says: BN254 pairing precompile decides proof validity
  for:
  - action
  - evidence-1
  - justification
  - what
- id: ret
  source: '0x433fe66eeb710a6a0f5c70d4cd2a815a078002b1'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  has: finalPairing()
  line: 1703
  says: verification ends with the final pairing check before returning true
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
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract verifies PLONK proofs for ZKsync OS chain batches using BN254 curve precompiles and a final pairing check. A quantum attacker who recovers the setup trapdoor can make a false batch proof pass this pairing check.

## Evidence

- [finalPairing](https://etherscan.io/address/0x433fe66eeb710a6a0f5c70d4cd2a815a078002b1#code) calls the BN254 pairing precompile and reverts if the pairing fails.
- [pointMulAndAddIntoDest](https://etherscan.io/address/0x433fe66eeb710a6a0f5c70d4cd2a815a078002b1#code) combines proof points with ecMul and ecAdd.
- [The verifier](https://etherscan.io/address/0x433fe66eeb710a6a0f5c70d4cd2a815a078002b1#code) returns true once the final pairing step passes.

## Reviewer notes

### Mechanism

ZKsyncOSDualVerifier routes type-2 proofs to plonkVerifiers[version], which is this contract for versions 0 and 6. Here, loadProof, initializeTranscript, verifyQuotientEvaluation, prepareQueries and prepareAggregatedCommitment run first (lines 1688-1700). They combine commitments with ecMul (precompile 7, lines 394 and 437) and ecAdd (precompile 6, lines 405, 416, 427 and 441). finalPairing then checks e(P, G2_0)·e(X, G2_1) through precompile 8 (line 1673), and the contract returns true (lines 1705-1706). Soundness depends on the KZG setup trapdoor staying unknown. Shor's algorithm recovers it from the public SRS points, so a forged proof passes and the batch's L2→L1 logs authorise withdrawals from the shared vault.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable; no admin slot read.
- Ruled out: Contract itself holds no funds.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
