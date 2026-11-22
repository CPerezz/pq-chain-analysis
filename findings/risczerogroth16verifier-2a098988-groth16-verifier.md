---
id: risczerogroth16verifier-2a098988-groth16-verifier
format: 2
title: RISC Zero Groth16 verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Quantum attack recovers the setup trapdoor; MEDIUM since RISC Zero can route to a new verifier and
  stop this one.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2a098988600d87650fb061ffaff08b97149fa84d'
  name: RiscZeroGroth16Verifier
  project: risc-zero
  code: verified
  code_url: https://etherscan.io/address/0x2a098988600d87650fb061ffaff08b97149fa84d#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5541
impact: funds-loss
action: Add a post-quantum (STARK/FRI) verifier to the router under a new selector and call estop() on this Groth16
  route.
evidence_level: source
checks:
- id: c4
  source: '0x2a098988600d87650fb061ffaff08b97149fa84d'
  file: src/groth16/Groth16Verifier.sol
  line: 168
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: Proof is accepted by the BN254 pairing precompile check.
  for:
  - action
  - evidence-3
  - justification
  - what
- id: c5
  source: '0x2a098988600d87650fb061ffaff08b97149fa84d'
  file: src/groth16/RiscZeroGroth16Verifier.sol
  line: 166
  has: bool verified = this.verifyProof(
  says: _verifyIntegrity relies on verifyProof for the seal.
  for:
  - evidence-2
  - justification
  - what
- id: v-verify
  source: '0x2a098988600d87650fb061ffaff08b97149fa84d'
  file: src/groth16/RiscZeroGroth16Verifier.sol
  has: function verify(bytes calldata seal, bytes32 imageId, bytes32 journalDigest) external view {
  line: 145
  says: verify takes seal, imageId and journalDigest.
  for:
  - evidence-1
  - what
- id: v-claim
  source: '0x2a098988600d87650fb061ffaff08b97149fa84d'
  file: src/groth16/RiscZeroGroth16Verifier.sol
  has: _verifyIntegrity(seal, ReceiptClaimLib.ok(imageId, journalDigest).digest());
  line: 146
  says: Claim digest is built from imageId and journalDigest.
  for:
  - evidence-1
  - what
- id: v-revert
  source: '0x2a098988600d87650fb061ffaff08b97149fa84d'
  file: src/groth16/RiscZeroGroth16Verifier.sol
  has: revert VerificationFailed();
  line: 181
  says: Reverts only when the Groth16 check fails.
  for:
  - evidence-2
- id: v-delta
  source: '0x2a098988600d87650fb061ffaff08b97149fa84d'
  file: src/groth16/Groth16Verifier.sol
  has: uint256 constant deltax1 =
  line: 40
  says: Verifying key points are hard-coded constants.
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
  who: Review03 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract checks RISC Zero zkVM receipts: verify accepts a seal when a Groth16 pairing check on BN254 against a hard-coded verifying key passes. A quantum attacker who recovers the setup trapdoor can build a seal that passes for any image ID and journal, and consumers trust the forged receipt.

## Evidence

- [verify](https://etherscan.io/address/0x2a098988600d87650fb061ffaff08b97149fa84d#code) builds the claim digest from imageId and journalDigest and passes it to _verifyIntegrity.
- [_verifyIntegrity](https://etherscan.io/address/0x2a098988600d87650fb061ffaff08b97149fa84d#code) calls verifyProof on the decoded seal and reverts only if it returns false.
- [verifyProof](https://etherscan.io/address/0x2a098988600d87650fb061ffaff08b97149fa84d#code) decides with the BN254 pairing precompile against constant verifying-key points.

## Reviewer notes

### Mechanism

Consumers call RiscZeroVerifierRouter.verify; the router forwards selector 0x73c457ba through an emergency-stop wrapper to this contract. RiscZeroGroth16Verifier.verify (line 145) computes ReceiptClaimLib.ok(imageId, journalDigest).digest() and calls _verifyIntegrity (line 155), which checks the 4-byte SELECTOR (line 159), splits the claim digest into two 128-bit public signals, decodes the Groth16 seal (a, b, c) and calls this.verifyProof (line 166) with CONTROL_ROOT_0/1, claim halves and BN254_CONTROL_ID. Groth16Verifier.verifyProof (line 69) computes vk_x with ecMul/ecAdd precompiles (lines 91, 101) and runs the ecpairing precompile (line 168) against hard-coded alpha, beta, gamma, delta. Knowledge of the trapdoor (obtainable by solving discrete logs on BN254 with a quantum computer) lets an attacker produce (a, b, c) satisfying the pairing for arbitrary public signals, so any claim verifies.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not a proxy and holds no funds itself.
- Ruled out: No admin in this contract; the fix is via the router and e-stop.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
