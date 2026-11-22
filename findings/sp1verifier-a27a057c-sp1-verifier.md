---
id: sp1verifier-a27a057c-sp1-verifier
format: 2
title: SP1 Groth16 verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Proofs rest on a BN254 trusted setup; MEDIUM because the gateway owner can freeze this route without
  a protocol change.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa27a057cab1a4798c6242f6ee5b2416b7cd45e5d'
  name: SP1Verifier
  project: succinct
  code: verified
  code_url: https://etherscan.io/address/0xa27a057cab1a4798c6242f6ee5b2416b7cd45e5d#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Freeze this verifier's route in the SP1 gateway and route consumers to a hash-based STARK verifier.
evidence_level: source
checks:
- id: c1
  source: '0xa27a057cab1a4798c6242f6ee5b2416b7cd45e5d'
  file: src/v4.0.0-rc.3/SP1VerifierGroth16.sol
  line: 39
  has: function verifyProof(
  says: verifyProof is the verifier entry point
  for:
  - action
  - justification
  - what
- id: s-verify
  source: '0xa27a057cab1a4798c6242f6ee5b2416b7cd45e5d'
  file: src/v4.0.0-rc.3/SP1VerifierGroth16.sol
  has: this.Verify(proof, inputs);
  line: 55
  says: Proof is checked by the inherited Groth16 verifier
  for:
  - evidence-1
  - justification
  - what
- id: s-selector
  source: '0xa27a057cab1a4798c6242f6ee5b2416b7cd45e5d'
  file: src/v4.0.0-rc.3/SP1VerifierGroth16.sol
  has: if (receivedSelector != expectedSelector) {
  line: 46
  says: Proof prefix must match VERIFIER_HASH
  for:
  - evidence-1
- id: s-contract
  source: '0xa27a057cab1a4798c6242f6ee5b2416b7cd45e5d'
  file: src/v4.0.0-rc.3/SP1VerifierGroth16.sol
  has: contract SP1Verifier is Groth16Verifier, ISP1VerifierWithHash {
  line: 10
  says: Contract is a Groth16 verifier
  for:
  - evidence-2
  - what
- id: s-inputs
  source: '0xa27a057cab1a4798c6242f6ee5b2416b7cd45e5d'
  file: src/v4.0.0-rc.3/SP1VerifierGroth16.sol
  has: inputs[0] = uint256(programVKey);
  line: 52
  says: Program key is a public input of the proof
  for:
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review11 (Claude), finding review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This immutable SP1 verifier accepts a Groth16 proof on BN254 for a program key and public values. A quantum attacker holding the setup trapdoor could make a proof of any program output pass this check.

## Evidence

- [verifyProof](https://etherscan.io/address/0xa27a057cab1a4798c6242f6ee5b2416b7cd45e5d#code) checks the selector, then calls the Groth16 Verify on the proof.
- [SP1Verifier](https://etherscan.io/address/0xa27a057cab1a4798c6242f6ee5b2416b7cd45e5d#code) inherits Groth16Verifier.

## Reviewer notes

### Mechanism

verifyProof (line 39) compares the first 4 bytes of proofBytes with VERIFIER_HASH (lines 44-48), hashes publicValues with sha256 into a BN254 field element (line 50), places programVKey and the digest as public inputs (lines 51-53), decodes eight uint256 proof elements (line 54) and calls this.Verify (line 55), the inherited gnark Groth16Verifier that ends in the BN254 pairing check. Groth16 soundness depends on the setup trapdoor staying unknown. A quantum attacker could recover it and forge proofs. Per the finding, this contract is reached through an open route in Succinct's Groth16 gateway, which the owner Safe can freeze.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; holds no funds itself.
- Ruled out: No calls in the last 30 days.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
