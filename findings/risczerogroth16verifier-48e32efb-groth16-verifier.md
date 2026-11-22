---
id: risczerogroth16verifier-48e32efb-groth16-verifier
format: 2
title: RISC Zero v2 Groth16 verifier accepts receipts a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Groth16 on BN254 falls to a recovered setup trapdoor; callers must repoint to a post-quantum verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x48e32efbe22e180a3ffe617f4955cd83b983dd98'
  name: RiscZeroGroth16Verifier
  project: risc-zero
  code: verified
  code_url: https://etherscan.io/address/0x48e32efbe22e180a3ffe617f4955cd83b983dd98#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Repoint any remaining callers to a post-quantum verifier for RISC Zero receipts, such as a STARK verifier
  behind the router.
evidence_level: source
checks:
- id: c1
  source: '0x48e32efbe22e180a3ffe617f4955cd83b983dd98'
  file: node_modules/risc0-ethereum/contracts/src/groth16/RiscZeroGroth16Verifier.sol
  line: 165
  has: bool verified = this.verifyProof(
  says: the integrity check accepts the seal based on verifyProof
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c2
  source: '0x48e32efbe22e180a3ffe617f4955cd83b983dd98'
  file: node_modules/risc0-ethereum/contracts/src/groth16/Groth16Verifier.sol
  line: 69
  has: function verifyProof(
  says: verifyProof is the snarkjs Groth16 verifier
  for:
  - evidence-3
- id: c5
  source: '0x48e32efbe22e180a3ffe617f4955cd83b983dd98'
  file: node_modules/risc0-ethereum/contracts/src/groth16/Groth16Verifier.sol
  line: 168
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: the decision is a BN254 pairing check via precompile 8
  for:
  - evidence-3
  - justification
  - what
- id: v-verify
  source: '0x48e32efbe22e180a3ffe617f4955cd83b983dd98'
  file: node_modules/risc0-ethereum/contracts/src/groth16/RiscZeroGroth16Verifier.sol
  has: _verifyIntegrity(seal, ReceiptClaimLib.ok(imageId, journalDigest).digest());
  line: 145
  says: verify checks a claim built from the caller's image ID and journal digest
  for:
  - evidence-1
  - what
- id: v-claim
  source: '0x48e32efbe22e180a3ffe617f4955cd83b983dd98'
  file: node_modules/risc0-ethereum/contracts/src/groth16/RiscZeroGroth16Verifier.sol
  has: (bytes16 claim0, bytes16 claim1) = splitDigest(claimDigest);
  line: 163
  says: the claim digest becomes the Groth16 public inputs
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
  who: Review03 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract checks RISC Zero zkVM receipts by running a Groth16 pairing check on BN254 against a hard-coded verifying key. A quantum attacker who recovers the setup trapdoor can build a seal that passes for any image ID and journal, and any contract calling this verifier trusts it.

## Evidence

- [verify](https://etherscan.io/address/0x48e32efbe22e180a3ffe617f4955cd83b983dd98#code) builds the claim digest from the image ID and journal digest and passes it to the integrity check.
- [_verifyIntegrity](https://etherscan.io/address/0x48e32efbe22e180a3ffe617f4955cd83b983dd98#code) accepts the seal when verifyProof returns true.
- [verifyProof](https://etherscan.io/address/0x48e32efbe22e180a3ffe617f4955cd83b983dd98#code) decides with the BN254 pairing precompile against the fixed verifying key.

## Reviewer notes

### Mechanism

verify(seal, imageId, journalDigest) (line 144) computes ReceiptClaimLib.ok(imageId, journalDigest).digest() and calls _verifyIntegrity (line 145). _verifyIntegrity checks the 4-byte SELECTOR (line 158), splits the claim digest into two 128-bit public inputs (line 163), decodes the Groth16 seal (line 164) and calls this.verifyProof (line 165) with the control root, claim halves and BN254 control ID. Groth16Verifier.verifyProof (line 69) computes vk_x with precompiles 7 and 6 (lines 91, 101) and runs the pairing check with precompile 8 (line 168) against the hard-coded alpha, beta, gamma and delta constants. Someone who knows the setup trapdoor (toxic waste) can produce A, B, C satisfying the pairing equation for any public inputs, so any claim verifies. This v2.0.0 build has no admin or upgrade path. The router's route for its selector leads to a different, paused wrapper, so it is reachable only by contracts that call it directly.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract is not a proxy and holds no funds.
- Ruled out: The router does not route to this build.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
