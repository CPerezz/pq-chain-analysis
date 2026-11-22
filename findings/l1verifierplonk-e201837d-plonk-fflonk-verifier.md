---
id: l1verifierplonk-e201837d-plonk-fflonk-verifier
format: 2
title: ZKsync L1VerifierPlonk accepts BN254 PLONK proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Proof soundness rests on the BN254 pairing; ZKsync governance can repoint chains to a new verifier,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe201837d151e5ac33af3305f287ad6f6a7dfccd7'
  name: L1VerifierPlonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0xe201837d151e5ac33af3305f287ad6f6a7dfccd7#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace the BN254 PLONK wrapper with a hash-based STARK/FRI verifier and repoint chains to it via governance.
evidence_level: source
checks:
- id: c1
  source: '0xe201837d151e5ac33af3305f287ad6f6a7dfccd7'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 394
  has: if iszero(staticcall(gas(), 7, 0, 0x60, dest, 0x40)) {
  says: Scalar multiplication uses the BN254 ecMul precompile.
  for:
  - justification
- id: c5
  source: '0xe201837d151e5ac33af3305f287ad6f6a7dfccd7'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 437
  has: let success := staticcall(gas(), 7, 0, 0x60, 0, 0x40)
  says: pointMulAndAddIntoDest calls the ecMul precompile.
  for:
  - evidence-2
  - what
- id: c6
  source: '0xe201837d151e5ac33af3305f287ad6f6a7dfccd7'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 441
  has: success := and(success, staticcall(gas(), 6, 0x00, 0x80, dest, 0x40))
  says: pointMulAndAddIntoDest calls the ecAdd precompile.
  for:
  - evidence-2
- id: c7
  source: '0xe201837d151e5ac33af3305f287ad6f6a7dfccd7'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 1673
  has: let success := staticcall(gas(), 8, 0, 0x180, 0x00, 0x20)
  says: finalPairing checks the proof with the BN254 pairing precompile.
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

This contract checks PLONK proofs over BN254 for ZK Stack batches and accepts a proof when the final pairing check passes. With the setup trapdoor, a quantum attacker can build a proof of a false batch that passes this check.

## Evidence

- [finalPairing](https://etherscan.io/address/0xe201837d151e5ac33af3305f287ad6f6a7dfccd7#code) decides validity with the BN254 pairing precompile.
- [pointMulAndAddIntoDest](https://etherscan.io/address/0xe201837d151e5ac33af3305f287ad6f6a7dfccd7#code) combines proof points with the ecMul and ecAdd precompiles.

## Reviewer notes

### Mechanism

The verifier body runs loadProof, initializeTranscript, verifyQuotientEvaluation, prepareQueries, prepareAggregatedCommitment, then finalPairing (lines 1688-1703). Commitments are combined with ecMul (precompile 7, line 394/437) and ecAdd (precompile 6, lines 405, 416, 427, 441). finalPairing calls precompile 8 at line 1673 against fixed G2 setup elements and reverts on failure; otherwise it returns true (line 1705). The trapdoor of the BN254 setup lets a prover satisfy this pairing for false statements. Per kev's finding, this is the PLONK leg of DualVerifier 0x4d335c5c used by chain 51888; ZKsync governance can swap the verifier through a protocol upgrade.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable and has no admin.
- Ruled out: Holds no funds itself; exposure is through the shared L1 vault.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
