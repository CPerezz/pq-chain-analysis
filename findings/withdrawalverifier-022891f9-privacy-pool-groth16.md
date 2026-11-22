---
id: withdrawalverifier-022891f9-privacy-pool-groth16
format: 2
title: 0xbow WithdrawalVerifier accepts Groth16 proofs a quantum attacker could forge
status: confirmed
severity: CRITICAL
justification: Forged proofs pass this fixed BN254 Groth16 check and release pool funds; only new pools with new
  verifiers fix it.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x022891f938ae7fdc8ab9ead0fbf50aba8c897d6d'
  name: WithdrawalVerifier
  project: 0xbow
  code: verified
  code_url: https://etherscan.io/address/0x022891f938ae7fdc8ab9ead0fbf50aba8c897d6d#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3093
impact: funds-loss
action: Deploy new pools with a hash-based (STARK/FRI or WHIR) withdrawal verifier and wind down pools that use
  this one.
evidence_level: source
checks:
- id: c1
  source: '0x022891f938ae7fdc8ab9ead0fbf50aba8c897d6d'
  file: src/contracts/verifiers/WithdrawalVerifier.sol
  line: 81
  has: function verifyProof(uint256[2] calldata _pA, uint256[2][2] calldata _pB, uint256[2] calldata _pC, uint256[8]
    calldata _pubSignals) public view returns (bool) {
  says: verifyProof takes a Groth16 proof and 8 public signals.
  for:
  - evidence-1
  - what
- id: c4
  source: '0x022891f938ae7fdc8ab9ead0fbf50aba8c897d6d'
  file: src/contracts/verifiers/WithdrawalVerifier.sol
  line: 184
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: checkPairing calls the BN254 pairing precompile (address 8).
  for:
  - action
  - evidence-2
  - justification
  - what
- id: vk-const
  source: '0x022891f938ae7fdc8ab9ead0fbf50aba8c897d6d'
  file: src/contracts/verifiers/WithdrawalVerifier.sol
  has: uint256 constant deltax1
  line: 41
  says: Verifying key elements are compile-time constants.
  for:
  - action
  - evidence-3
  - justification
  - what
- id: pairing-result
  source: '0x022891f938ae7fdc8ab9ead0fbf50aba8c897d6d'
  file: src/contracts/verifiers/WithdrawalVerifier.sol
  has: isOk := and(success, mload(_pPairing))
  line: 186
  says: The proof is accepted if and only if the pairing check holds.
  for:
  - evidence-2
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
  rating: CRITICAL
reviews: []
related: []
---

## What happens

This contract checks Groth16 withdrawal proofs for 0xbow Privacy Pools against a hard-coded BN254 verifying key. With the setup trapdoor recovered from that key, a quantum attacker makes proofs for any public signals that this check accepts, and pools pay out on them.

## Evidence

- [verifyProof](https://etherscan.io/address/0x022891f938ae7fdc8ab9ead0fbf50aba8c897d6d#code) takes a Groth16 proof and eight public signals and returns a boolean.
- [checkPairing](https://etherscan.io/address/0x022891f938ae7fdc8ab9ead0fbf50aba8c897d6d#code) calls the BN254 pairing precompile at address 8 and returns its result.
- The [verifying key](https://etherscan.io/address/0x022891f938ae7fdc8ab9ead0fbf50aba8c897d6d#code) is held in constants, so it cannot be changed.

## Reviewer notes

### Mechanism

verifyProof (line 81) range-checks the eight public signals (lines 194-208). checkPairing then builds vk_x from the constant IC points via the ecMul and ecAdd precompiles (lines 98, 108, 125-139). It runs the Groth16 pairing equation over -A, B, alpha, beta, vk_x, gamma, C and delta through precompile 8 (line 184) and returns success AND result (line 186). All key values are constants (lines 31-72), so no admin path changes them. Per kev, PrivacyPool.withdraw in all 14 pools calls this verifier and pays withdrawnValue taken from the public signals. A CRQC recovers the Groth16 trapdoor from the BN254 key, and whoever holds that trapdoor can satisfy the pairing equation for arbitrary signals.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy, owner or holdings on this verifier.
- Ruled out: Funds sit in the pools, not here.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
