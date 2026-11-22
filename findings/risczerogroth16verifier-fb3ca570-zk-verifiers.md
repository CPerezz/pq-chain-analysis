---
id: risczerogroth16verifier-fb3ca570-zk-verifiers
format: 2
title: Taiko RISC Zero verifier accepts Groth16 proofs quantum attackers can forge
status: confirmed
severity: MEDIUM
justification: BN254 Groth16 has a trusted setup whose trapdoor a quantum attacker recovers; Taiko DAO fixes it
  via PQ verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xfb3ca570a5348fd101e65303eecdb5bf43c5548a'
  name: RiscZeroGroth16Verifier
  project: taiko
  code: verified
  code_url: https://etherscan.io/address/0xfb3ca570a5348fd101e65303eecdb5bf43c5548a#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Keep this BN254 verifier out of proof paths and move Taiko's RISC Zero checks to post-quantum verifiers.
evidence_level: source
checks:
- id: c1
  source: '0xfb3ca570a5348fd101e65303eecdb5bf43c5548a'
  file: node_modules/risc0-ethereum/contracts/src/groth16/RiscZeroGroth16Verifier.sol
  line: 165
  has: bool verified = this.verifyProof(
  says: _verifyIntegrity relies on the Groth16 verifyProof result
  for:
  - evidence-1
  - what
- id: c2
  source: '0xfb3ca570a5348fd101e65303eecdb5bf43c5548a'
  file: node_modules/risc0-ethereum/contracts/src/groth16/Groth16Verifier.sol
  line: 69
  has: function verifyProof(
  says: Groth16 verifyProof entry point
  for:
  - what
- id: c3
  source: '0xfb3ca570a5348fd101e65303eecdb5bf43c5548a'
  file: node_modules/risc0-ethereum/contracts/src/groth16/Groth16Verifier.sol
  line: 168
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: pairing check uses the BN254 precompile 8
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xfb3ca570a5348fd101e65303eecdb5bf43c5548a'
  file: node_modules/risc0-ethereum/contracts/src/groth16/Groth16Verifier.sol
  line: 91
  has: success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)
  says: ecmul precompile 7 on BN254
  for:
  - evidence-3
- id: c5
  source: '0xfb3ca570a5348fd101e65303eecdb5bf43c5548a'
  file: node_modules/risc0-ethereum/contracts/src/groth16/Groth16Verifier.sol
  line: 101
  has: success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: ecadd precompile 6 on BN254
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

This contract checks RISC Zero receipts by verifying a Groth16 seal with a BN254 pairing against a fixed verification key. A quantum attacker who recovers the setup trapdoor builds seals for false claims that this check accepts.

## Evidence

- [_verifyIntegrity](https://etherscan.io/address/0xfb3ca570a5348fd101e65303eecdb5bf43c5548a#code) accepts a receipt when the Groth16 verifyProof call returns true.
- [checkPairing](https://etherscan.io/address/0xfb3ca570a5348fd101e65303eecdb5bf43c5548a#code) calls the BN254 pairing precompile at address 8.
- [g1_mulAccC](https://etherscan.io/address/0xfb3ca570a5348fd101e65303eecdb5bf43c5548a#code) builds the public-input point with the BN254 ecmul and ecadd precompiles.

## Reviewer notes

### Mechanism

verify(seal,imageId,journalDigest) and verifyIntegrity(receipt) call _verifyIntegrity (lines 154-182). It checks the 4-byte SELECTOR (line 158), decodes the Groth16 seal and calls this.verifyProof (line 165) with control roots, the split claim digest and BN254_CONTROL_ID. Groth16Verifier.verifyProof (line 69) computes vk_x with precompiles 7/6 (lines 91, 101) and runs the pairing check with precompile 8 (line 168). With the setup trapdoor, false claims verify. Kev's finding: the Pacaya Risc0Verifier proxy called this contract until it was upgraded to an implementation using another verifier. No live Taiko path reaches this contract now.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin read.
- Ruled out: Holds no funds itself.
- Ruled out: No calls in the study's 30-day window.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
