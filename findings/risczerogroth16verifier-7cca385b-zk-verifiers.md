---
id: risczerogroth16verifier-7cca385b-zk-verifiers
format: 2
title: Taiko RISC Zero Groth16 verifier accepts BN254 proofs a quantum attacker forges
status: confirmed
severity: MEDIUM
justification: BN254 Groth16 trapdoor is recoverable with a quantum computer; Taiko DAO can fix by upgrading to
  post-quantum verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7cca385bdc790c25924333f5adb7f4967f5d1599'
  name: RiscZeroGroth16Verifier
  project: taiko
  code: verified
  code_url: https://etherscan.io/address/0x7cca385bdc790c25924333f5adb7f4967f5d1599#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace BN254 Groth16 verification with a post-quantum proof verifier via a DAO upgrade of the inbox verifiers.
evidence_level: source
checks:
- id: c1
  source: '0x7cca385bdc790c25924333f5adb7f4967f5d1599'
  file: node_modules/risc0-ethereum/contracts/src/groth16/RiscZeroGroth16Verifier.sol
  line: 166
  has: bool verified = this.verifyProof(
  says: _verifyIntegrity requires the Groth16 verifyProof result
  for:
  - evidence-1
  - what
- id: c3
  source: '0x7cca385bdc790c25924333f5adb7f4967f5d1599'
  file: node_modules/risc0-ethereum/contracts/src/groth16/Groth16Verifier.sol
  line: 168
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: pairing check uses BN254 precompile 8
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x7cca385bdc790c25924333f5adb7f4967f5d1599'
  file: node_modules/risc0-ethereum/contracts/src/groth16/Groth16Verifier.sol
  line: 91
  has: success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)
  says: ecmul precompile 7 for public input combination
  for:
  - evidence-3
  - what
- id: c5
  source: '0x7cca385bdc790c25924333f5adb7f4967f5d1599'
  file: node_modules/risc0-ethereum/contracts/src/groth16/Groth16Verifier.sol
  line: 101
  has: success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: ecadd precompile 6 for public input combination
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
  who: Review16 (verified source of the Shasta inbox, ZkRequiredVerifier, SP1Verifier and Risc0Verifier wrappers;
    on-chain reads at block 26,431,535)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: top-callers-classification
  who: Review15 (review of the former finding unidentified-fb3ca570-snark-verifier, merged here)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract verifies RISC Zero receipts with a Groth16 proof checked by BN254 pairings. A quantum attacker who recovers the setup trapdoor can build proofs it accepts for false claims.

## Evidence

- [_verifyIntegrity](https://etherscan.io/address/0x7cca385bdc790c25924333f5adb7f4967f5d1599#code) accepts a seal only if the Groth16 verifyProof call returns true.
- [checkPairing](https://etherscan.io/address/0x7cca385bdc790c25924333f5adb7f4967f5d1599#code) decides validity with the BN254 pairing precompile at address 8.
- [g1_mulAccC](https://etherscan.io/address/0x7cca385bdc790c25924333f5adb7f4967f5d1599#code) combines public inputs with BN254 ecmul and ecadd precompiles.

## Reviewer notes

### Mechanism

verify/verifyIntegrity -> _verifyIntegrity (RiscZeroGroth16Verifier.sol l.155-183) checks the 4-byte selector, decodes the seal (a,b,c) and calls this.verifyProof (l.166) with control root, claim digest halves and BN254 control id as public signals. Groth16Verifier.verifyProof (l.69) builds vk_x with ecmul/ecadd precompiles 7 and 6 (l.91, l.101) and checks the pairing equation via precompile 8 (l.168). Knowledge of the trusted-setup trapdoor (recoverable via discrete logs on BN254 with a CRQC) lets an attacker produce (a,b,c) satisfying the pairing for any claim. Per kev, this copy is the Groth16 verifier of Taiko's retired Pacaya Risc0Verifier proxy and has never verified a proof; the live path routes selector 0x73c457ba to a different 3.0.0 verifier.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not on the live Shasta proof path; Pacaya inbox no longer writes checkpoints.
- Ruled out: No calls in the study window; holds no funds.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
