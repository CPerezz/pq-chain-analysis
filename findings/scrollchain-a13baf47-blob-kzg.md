---
id: scrollchain-a13baf47-blob-kzg
format: 2
title: Scroll ScrollChain trusts KZG blob openings a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Batch data binding rests on the KZG setup; Scroll's owner can upgrade ScrollChain to calldata batches,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-8
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa13baf47339d63b743e7da8741db5456dac1e556'
  name: ScrollChain
  project: scroll
  code: verified
  code_url: https://etherscan.io/address/0x0a20703878e68e587c59204cc0ea86098b8c3ba7#code
  proxy_of: '0x0a20703878e68e587c59204cc0ea86098b8c3ba7'
  copies: 1
  upgradeable: 'yes'
  admin: '0xeb803eb3f501998126bf37bb823646ed3d59d072'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6139
impact: funds-locked
action: Upgrade ScrollChain to a calldata batch codec with matching batch circuits and verifier, removing the KZG
  dependency.
evidence_level: source
checks:
- id: c1
  source: '0x0a20703878e68e587c59204cc0ea86098b8c3ba7'
  file: src/L1/rollup/ScrollChain.sol
  line: 590
  has: _blobVersionedHash := blobhash(index)
  says: Reads the blob versioned hash with the blobhash opcode.
  for:
  - evidence-1
  - justification
  - what
- id: v7-only
  source: '0x0a20703878e68e587c59204cc0ea86098b8c3ba7'
  file: src/L1/rollup/ScrollChain.sol
  has: if (version < 7) {
  line: 605
  says: Commits with batch versions below 7 are rejected.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: empty
  source: '0x0a20703878e68e587c59204cc0ea86098b8c3ba7'
  file: src/L1/rollup/ScrollChain.sol
  has: if (i == 0) revert ErrorBatchIsEmpty();
  line: 615
  says: A commit without any blob reverts.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: store-hash
  source: '0x0a20703878e68e587c59204cc0ea86098b8c3ba7'
  file: src/L1/rollup/ScrollChain.sol
  has: BatchHeaderV7Codec.storeBlobVersionedHash(batchPtr, blobVersionedHash);
  line: 625
  says: The blob versioned hash is written into the batch header.
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
  who: Review14 (ScrollChain source, zkvm-prover source, on-chain reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

ScrollChain commits rollup batches only as EIP-4844 blobs and records each blob's versioned hash in the batch header. With the KZG trapdoor, a quantum attacker could open a posted commitment to other data, so batches finalize against data users cannot rebuild, locking bridge withdrawals.

## Evidence

- [_getBlobVersionedHash](https://etherscan.io/address/0x0a20703878e68e587c59204cc0ea86098b8c3ba7#code) reads the blob's versioned hash with blobhash.
- [_commitBatchesFromV7](https://etherscan.io/address/0x0a20703878e68e587c59204cc0ea86098b8c3ba7#code) reverts when a commit carries no blob and rejects versions below 7.
- [_commitBatchesFromV7](https://etherscan.io/address/0x0a20703878e68e587c59204cc0ea86098b8c3ba7#code) stores the blob versioned hash in the batch header that is hashed.

## Reviewer notes

### Mechanism

commitBatches / commitAndFinalizeBatch call _commitBatchesFromV7 (line 599). It rejects version < 7 (lines 605-607), loops over blobs via _getBlobVersionedHash (line 613, blobhash at line 590), reverts ErrorBatchIsEmpty when there is no blob (line 615), and stores the versioned hash in the V7 header (line 625) before computing the batch hash (line 626). finalizeBundlePostEuclidV2 feeds the batch hash into the bundle proof's public input. Per kev, the KZG opening of the blob to the executed data is checked inside the zkVM batch circuit against the EIP-4844 ceremony G2 point, not by the 0x0a precompile. A trapdoor holder could open the commitment to different data, so finalized state cannot be reconstructed from published blobs and withdrawal proofs cannot be built.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Theft through a forged validity proof is a separate finding (BN254 verifier).
- Ruled out: Substituted data must still be valid L2 transactions, so the gain is withholding, not theft.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
