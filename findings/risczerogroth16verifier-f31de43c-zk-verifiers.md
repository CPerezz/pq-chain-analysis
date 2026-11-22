---
id: risczerogroth16verifier-f31de43c-zk-verifiers
format: 2
title: Taiko RISC Zero verifier accepts BN254 proofs a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: Trusted-setup BN254 Groth16 proofs are forgeable with the trapdoor; Taiko DAO can upgrade to post-quantum
  verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf31de43cc0cf75245ade63d3dabf58d4332855e9'
  name: RiscZeroGroth16Verifier
  project: taiko
  code: verified
  code_url: https://etherscan.io/address/0xf31de43cc0cf75245ade63d3dabf58d4332855e9#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace BN254 Groth16 verifiers on Taiko's proving path with post-quantum verifiers via a DAO inbox upgrade.
evidence_level: source
checks:
- id: c1
  source: '0xf31de43cc0cf75245ade63d3dabf58d4332855e9'
  file: node_modules/risc0-ethereum/contracts/src/groth16/RiscZeroGroth16Verifier.sol
  line: 165
  has: bool verified = this.verifyProof(
  says: _verifyIntegrity calls verifyProof on the decoded seal.
  for:
  - evidence-1
  - what
- id: c2
  source: '0xf31de43cc0cf75245ade63d3dabf58d4332855e9'
  file: node_modules/risc0-ethereum/contracts/src/groth16/Groth16Verifier.sol
  line: 69
  has: function verifyProof(
  says: Groth16 verifyProof entry point.
  for:
  - evidence-2
  - justification
- id: c3
  source: '0xf31de43cc0cf75245ade63d3dabf58d4332855e9'
  file: node_modules/risc0-ethereum/contracts/src/groth16/Groth16Verifier.sol
  line: 168
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: Verification is a BN254 pairing precompile call.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xf31de43cc0cf75245ade63d3dabf58d4332855e9'
  file: node_modules/risc0-ethereum/contracts/src/groth16/Groth16Verifier.sol
  line: 91
  has: success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)
  says: Public inputs are combined with the BN254 ecmul precompile.
  for:
  - what
- id: ver
  source: '0xf31de43cc0cf75245ade63d3dabf58d4332855e9'
  file: node_modules/risc0-ethereum/contracts/src/groth16/RiscZeroGroth16Verifier.sol
  has: string public constant VERSION = "1.2.0";
  line: 58
  says: Version 1.2.0.
  for:
  - what
- id: rev
  source: '0xf31de43cc0cf75245ade63d3dabf58d4332855e9'
  file: node_modules/risc0-ethereum/contracts/src/groth16/RiscZeroGroth16Verifier.sol
  has: revert VerificationFailed();
  line: 180
  says: A failed verification reverts.
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

This RISC Zero 1.2.0 verifier accepts a receipt when a Groth16 pairing check on BN254 passes. A quantum attacker who recovers the setup trapdoor can build seals for false claims that pass this check.

## Evidence

- [_verifyIntegrity](https://etherscan.io/address/0xf31de43cc0cf75245ade63d3dabf58d4332855e9#code) reverts unless verifyProof returns true for the decoded seal.
- [verifyProof](https://etherscan.io/address/0xf31de43cc0cf75245ade63d3dabf58d4332855e9#code) ends in a BN254 pairing precompile call against fixed verification-key constants.

## Reviewer notes

### Mechanism

verify(seal,imageId,journalDigest) (line 144) and verifyIntegrity (line 149) call _verifyIntegrity (line 154), which checks the 4-byte SELECTOR (line 158), decodes the Seal (line 164), and calls this.verifyProof (line 165) with control root halves, claim digest halves and BN254_CONTROL_ID as public inputs. Groth16Verifier.verifyProof (line 69) builds vk_x with ecmul/ecadd precompiles 7 and 6 (lines 91, 101) and checks the pairing with precompile 8 (line 168). If it fails, it reverts with VerificationFailed (line 180). Groth16 soundness rests on the trusted-setup trapdoor staying secret. A CRQC can derive it from the setup's public BN254 points and forge seals for any claim.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Kev finds this copy is no longer referenced by any live Taiko wrapper; the RISC Zero router reports SelectorRemoved for its selector.
- Ruled out: Holds about $0 and had no calls in the study window.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
