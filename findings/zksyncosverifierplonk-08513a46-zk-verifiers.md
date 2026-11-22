---
id: zksyncosverifierplonk-08513a46-zk-verifiers
format: 2
title: ADI Chain PLONK verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Pairing-based proof check breaks with the setup trapdoor; ADI governance can swap in a post-quantum
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x08513a4646d1bc8c348c67a3680bb19626e7f13f'
  name: ZKsyncOSVerifierPlonk
  project: adi-chain
  code: verified
  code_url: https://etherscan.io/address/0x08513a4646d1bc8c348c67a3680bb19626e7f13f#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1121
impact: funds-loss
action: Register a post-quantum verifier in ZKsyncOSDualVerifier and remove the BN254 legs through ADI Governance.
evidence_level: source
checks:
- id: c1
  source: '0x08513a4646d1bc8c348c67a3680bb19626e7f13f'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 394
  has: if iszero(staticcall(gas(), 7, 0, 0x60, dest, 0x40)) {
  says: ecMul precompile (BN254) used for point multiplication.
  for:
  - evidence-2
  - what
- id: c2
  source: '0x08513a4646d1bc8c348c67a3680bb19626e7f13f'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 405
  has: if iszero(staticcall(gas(), 6, 0x00, 0x80, dest, 0x40)) {
  says: ecAdd precompile (BN254) used for point addition.
  for:
  - evidence-2
  - what
- id: c7
  source: '0x08513a4646d1bc8c348c67a3680bb19626e7f13f'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 1673
  has: let success := staticcall(gas(), 8, 0, 0x180, 0x00, 0x20)
  says: Final check calls the BN254 pairing precompile.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: pairfail
  source: '0x08513a4646d1bc8c348c67a3680bb19626e7f13f'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  has: 'revertWithMessage(29, "finalPairing: pairing failure")'
  line: 1678
  says: Verification reverts when the BN254 pairing check fails.
  for:
  - evidence-1
  - justification
  - what
- id: rettrue
  source: '0x08513a4646d1bc8c348c67a3680bb19626e7f13f'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  has: mstore(0, true)
  line: 1705
  says: verify returns true after all steps including the pairing pass.
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

This contract checks ZKsync OS batch proofs as PLONK proofs over BN254 and accepts one only if the final pairing check passes. A quantum attacker who recovers the setup trapdoor can build a false proof that this check accepts.

## Evidence

- [finalPairing](https://etherscan.io/address/0x08513a4646d1bc8c348c67a3680bb19626e7f13f#code) calls the BN254 pairing precompile and reverts if the pairing fails.
- [pointMulIntoDest and pointAddIntoDest](https://etherscan.io/address/0x08513a4646d1bc8c348c67a3680bb19626e7f13f#code) build the commitments with BN254 ecMul and ecAdd.
- [verify](https://etherscan.io/address/0x08513a4646d1bc8c348c67a3680bb19626e7f13f#code) returns true once the pairing step completes.

## Reviewer notes

### Mechanism

verify runs loadProof, initializeTranscript, verifyQuotientEvaluation, prepareQueries, prepareAggregatedCommitment and finalPairing (lines 1688-1703). It then returns true (line 1705). Commitments are combined with ecMul (precompile 7, lines 394, 437) and ecAdd (precompile 6, lines 405, 416, 427, 441), and modexp (precompile 5, line 383) is used for field arithmetic. finalPairing calls ecPairing (precompile 8, line 1673) against fixed G2 elements and reverts on failure (line 1678). Soundness rests on the BN254 trusted-setup trapdoor staying secret. A quantum attacker who recovers the trapdoor through discrete logs can produce a proof for false public inputs that passes this check. Kev lists this deployment as a retired verifier of ADI Chain that ZKsyncOSDualVerifier routed to; per kev, the live router is configurable by ADI Governance.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; holds no funds itself.
- Ruled out: No ECDSA signature check in this contract.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
