---
id: sp1verifier-50acfbed-sp1-verifier
format: 2
title: SP1 Groth16 v5 verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged BN254 proofs pass this immutable verifier; Succinct and consumers can reroute to a hash-based
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x50acfbedecf4cbe350e1a86fc6f03a821772f1e5'
  name: SP1Verifier
  project: succinct
  code: verified
  code_url: https://etherscan.io/address/0x50acfbedecf4cbe350e1a86fc6f03a821772f1e5#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 142
impact: funds-loss
action: Add a hash-based SP1 verifier route and freeze the routes to this BN254 Groth16 verifier.
evidence_level: source
checks:
- id: v-hash
  source: '0x50acfbedecf4cbe350e1a86fc6f03a821772f1e5'
  file: src/v5.0.0/SP1VerifierGroth16.sol
  has: return 0xa4594c59bbc142f3b81c3ecb7f50a7c34bc9af7c4c444b5d48b795427e285913;
  line: 26
  says: Verifier hash is a fixed constant.
  for:
  - justification
- id: v-sel
  source: '0x50acfbedecf4cbe350e1a86fc6f03a821772f1e5'
  file: src/v5.0.0/SP1VerifierGroth16.sol
  has: if (receivedSelector != expectedSelector) {
  line: 48
  says: Proof selector must match the verifier hash prefix.
  for:
  - evidence-1
- id: v-verify
  source: '0x50acfbedecf4cbe350e1a86fc6f03a821772f1e5'
  file: src/v5.0.0/SP1VerifierGroth16.sol
  has: this.Verify(proof, inputs);
  line: 57
  says: Acceptance rests on the Groth16 Verify call.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: v-groth
  source: '0x50acfbedecf4cbe350e1a86fc6f03a821772f1e5'
  file: src/v5.0.0/SP1VerifierGroth16.sol
  has: contract SP1Verifier is Groth16Verifier, ISP1VerifierWithHash {
  line: 10
  says: Contract inherits the Groth16 verifier.
  for:
  - justification
  - what
- id: v-inputs
  source: '0x50acfbedecf4cbe350e1a86fc6f03a821772f1e5'
  file: src/v5.0.0/SP1VerifierGroth16.sol
  has: inputs[0] = uint256(programVKey);
  line: 54
  says: Program key is a public input.
  for:
  - evidence-2
  - what
- id: v-hashpv
  source: '0x50acfbedecf4cbe350e1a86fc6f03a821772f1e5'
  file: src/v5.0.0/SP1VerifierGroth16.sol
  has: return sha256(publicValues) & bytes32(uint256((1 << 253) - 1));
  line: 34
  says: Public values are hashed with SHA-256 into a field element.
  for:
  - evidence-2
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

This immutable SP1 verifier accepts a program output when a Groth16 proof over BN254 verifies for the program key and public-values hash. With the setup trapdoor, a quantum attacker forges a proof for any output, and consumers relying on this verifier accept it.

## Evidence

- [verifyProof](https://etherscan.io/address/0x50acfbedecf4cbe350e1a86fc6f03a821772f1e5#code) checks only the 4-byte selector, then calls the Groth16 Verify.
- [verifyProof](https://etherscan.io/address/0x50acfbedecf4cbe350e1a86fc6f03a821772f1e5#code) binds the proof to programVKey and a SHA-256 digest of the public values.

## Reviewer notes

### Mechanism

SP1Verifier.verifyProof (SP1VerifierGroth16.sol lines 41-58) compares proofBytes[:4] with the first 4 bytes of VERIFIER_HASH (line 26, lines 46-50). It computes hashPublicValues (sha256 masked to 253 bits, line 34) and sets the inputs to programVKey and that digest (lines 54-55). It decodes eight uint256 proof words (line 56) and calls this.Verify (line 57), the inherited gnark Groth16Verifier, which ends in the BN254 pairing check. Anyone holding the Groth16 setup trapdoor, recoverable by a quantum computer, can produce a proof that passes for arbitrary public values. The contract has no admin and cannot be upgraded. Per kev it is reached via Succinct's Groth16 gateway, gateway 0xf35a4088 and OnChainProposer 0xe13e7aa1, whose admins must reroute.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
