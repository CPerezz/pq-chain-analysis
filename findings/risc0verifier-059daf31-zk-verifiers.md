---
id: risc0verifier-059daf31-zk-verifiers
format: 2
title: Taiko Risc0Verifier accepts BN254 Groth16 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Groth16 on BN254 relies on a trusted setup a quantum attacker can break; the Taiko DAO can upgrade
  to PQ verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x059daf31f571da48ab4e74ae12f64f907681cd8b'
  name: Risc0Verifier
  project: taiko
  code: verified
  code_url: https://etherscan.io/address/0x059daf31f571da48ab4e74ae12f64f907681cd8b#code
  copies: 1
  upgradeable: 'no'
  admin: '0x75ba76403b13b26ad1bec70d6ee937314eeacd0a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2148
impact: funds-loss
action: Replace the Groth16 verifier with a post-quantum proof verifier through a DAO-approved upgrade of the inbox
  verifier set.
evidence_level: source
checks:
- id: c1
  source: '0x059daf31f571da48ab4e74ae12f64f907681cd8b'
  file: contracts/layer1/verifiers/Risc0Verifier.sol
  line: 49
  has: function verifyProof(
  says: verifyProof is the proof check entry point.
  for:
  - justification
- id: s-agg
  source: '0x059daf31f571da48ab4e74ae12f64f907681cd8b'
  file: contracts/layer1/verifiers/Risc0Verifier.sol
  has: require(isImageTrusted[aggregationImageId], RISC_ZERO_INVALID_AGGREGATION_IMAGE_ID());
  line: 62
  says: Aggregation image ID must be trusted.
  for:
  - what
- id: s-blk
  source: '0x059daf31f571da48ab4e74ae12f64f907681cd8b'
  file: contracts/layer1/verifiers/Risc0Verifier.sol
  has: require(isImageTrusted[blockImageId], RISC_ZERO_INVALID_BLOCK_PROOF_IMAGE_ID());
  line: 64
  says: Block image ID must be trusted.
  for:
  - what
- id: s-call
  source: '0x059daf31f571da48ab4e74ae12f64f907681cd8b'
  file: contracts/layer1/verifiers/Risc0Verifier.sol
  has: (bool success,) = riscoGroth16Verifier.staticcall(
  line: 77
  says: Seal is checked by an external Groth16 verifier.
  for:
  - evidence-1
  - justification
  - what
- id: s-req
  source: '0x059daf31f571da48ab4e74ae12f64f907681cd8b'
  file: contracts/layer1/verifiers/Risc0Verifier.sol
  has: require(success, RISC_ZERO_INVALID_PROOF());
  line: 80
  says: Proof is accepted when the Groth16 call succeeds.
  for:
  - evidence-2
  - what
- id: s-imm
  source: '0x059daf31f571da48ab4e74ae12f64f907681cd8b'
  file: contracts/layer1/verifiers/Risc0Verifier.sol
  has: address public immutable riscoGroth16Verifier;
  line: 13
  says: Groth16 verifier address is immutable; changing it needs a new deployment.
  for:
  - action
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

This contract checks RISC Zero proofs for Taiko's inbox: it confirms both image IDs are trusted, then passes the seal to an external Groth16 verifier. The proof is accepted when that verifier call succeeds, so a quantum attacker who forges a Groth16 seal gets a false state transition accepted.

## Evidence

- [verifyProof](https://etherscan.io/address/0x059daf31f571da48ab4e74ae12f64f907681cd8b#code) staticcalls the immutable riscoGroth16Verifier with the seal.
- [verifyProof](https://etherscan.io/address/0x059daf31f571da48ab4e74ae12f64f907681cd8b#code) accepts the proof when that call succeeds.

## Reviewer notes

### Mechanism

Risc0Verifier.verifyProof (lines 49-81) decodes (seal, blockImageId, aggregationImageId). It requires both image IDs to be trusted (lines 62, 64), then builds a journal digest from the commitment hash. Lines 77-80 staticcall riscoGroth16Verifier.verify(seal, aggregationImageId, journalDigest) and require success. riscoGroth16Verifier is an immutable set in the constructor (line 35). Per kev, this is the RISC Zero router, which routes to a BN254 Groth16 verifier. ZkRequiredVerifier uses this contract as the RISC0_RETH sub-proof. A forged Groth16 seal therefore passes, and with a forged SP1 proof or an SGX signature it finalizes a false L2 state on L1.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The image ID allowlist does not help: an attacker reuses the trusted image IDs and forges only the seal.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
