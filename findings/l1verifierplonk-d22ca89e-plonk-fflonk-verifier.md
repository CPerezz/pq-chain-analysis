---
id: l1verifierplonk-d22ca89e-plonk-fflonk-verifier
format: 2
title: ZKsync PLONK verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Pairing-based proof breaks with the setup trapdoor; MEDIUM as ZKsync governance can repoint chains
  to a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd22ca89e8991fce568456914c616d303e3142395'
  name: L1VerifierPlonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0xd22ca89e8991fce568456914c616d303e3142395#code
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 29
impact: funds-loss
action: Repoint chains via protocol upgrade to a verifier that checks the hash-based STARK proof on-chain instead
  of the BN254 wrapper.
evidence_level: source
checks:
- id: c1
  source: '0xd22ca89e8991fce568456914c616d303e3142395'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 394
  has: if iszero(staticcall(gas(), 7, 0, 0x60, dest, 0x40)) {
  says: ecMul precompile used for point multiplication.
  for:
  - what
- id: c2
  source: '0xd22ca89e8991fce568456914c616d303e3142395'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 405
  has: if iszero(staticcall(gas(), 6, 0x00, 0x80, dest, 0x40)) {
  says: ecAdd precompile used for point addition.
  for:
  - what
- id: c5
  source: '0xd22ca89e8991fce568456914c616d303e3142395'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 437
  has: let success := staticcall(gas(), 7, 0, 0x60, 0, 0x40)
  says: ecMul inside pointMulAndAddIntoDest.
  for:
  - evidence-2
- id: c6
  source: '0xd22ca89e8991fce568456914c616d303e3142395'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 441
  has: success := and(success, staticcall(gas(), 6, 0x00, 0x80, dest, 0x40))
  says: ecAdd inside pointMulAndAddIntoDest.
  for:
  - evidence-2
- id: c7
  source: '0xd22ca89e8991fce568456914c616d303e3142395'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 1673
  has: let success := staticcall(gas(), 8, 0, 0x180, 0x00, 0x20)
  says: BN254 pairing precompile decides the final check.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: ret
  source: '0xd22ca89e8991fce568456914c616d303e3142395'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  has: mstore(0, true)
  line: 1705
  says: Verification returns true after all steps pass.
  for:
  - what
- id: fail
  source: '0xd22ca89e8991fce568456914c616d303e3142395'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  has: 'finalPairing: pairing failure'
  line: 1678
  says: The proof is rejected if the pairing check fails.
  for:
  - evidence-1
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

This contract is the PLONK leg that checks ZK Stack batch proofs over BN254 with elliptic-curve and pairing precompiles. A quantum attacker who recovers the setup trapdoor could build a proof for a false batch that passes the final pairing check.

## Evidence

- [finalPairing](https://etherscan.io/address/0xd22ca89e8991fce568456914c616d303e3142395#code) accepts the proof when the BN254 pairing precompile returns true.
- [pointMulAndAddIntoDest](https://etherscan.io/address/0xd22ca89e8991fce568456914c616d303e3142395#code) combines proof points with ecMul and ecAdd before the pairing.

## Reviewer notes

### Mechanism

The verifier body runs loadProof, initializeTranscript, verifyQuotientEvaluation, prepareQueries, prepareAggregatedCommitment and finalPairing (lines 1688-1703). Point arithmetic uses precompiles 6 and 7 (lines 394, 405, 416, 427, 437, 441). finalPairing calls precompile 8 at line 1673 and reverts on pairing failure at line 1677; otherwise the contract returns true (lines 1705-1706). Per kev's finding, a DualVerifier routes type-1 proofs to this leg and the verified batch's L2->L1 logs authorise withdrawals from the shared L1NativeTokenVault. Soundness rests on the KZG setup trapdoor, which discrete logs on BN254 expose to a quantum attacker.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds itself.
- Ruled out: No owner or upgrade path was read for this leg.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
