---
id: rollup-e37a2663-blob-kzg
format: 2
title: Aztec Rollup v3 trusts KZG blob openings that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged KZG openings finalize epochs without data; governance can register a new rollup version.
category: quantum-exposure
pattern: PQ-8
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe37a2663cc9c119ba41572c40fab0bbb23a5402f'
  name: Rollup
  project: aztec
  code: verified
  code_url: https://etherscan.io/address/0xe37a2663cc9c119ba41572c40fab0bbb23a5402f#code
  copies: 1
  admin: '0x1102471eb3378fee427121c9efcea452e4b6b75e'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 48528
impact: funds-locked
action: Register via governance a rollup version publishing data by calldata or a hash-committed scheme, and move
  portals to it.
evidence_level: source
checks:
- id: c1
  source: '0xe37a2663cc9c119ba41572c40fab0bbb23a5402f'
  file: src/core/libraries/rollup/BlobLib.sol
  line: 56
  has: blobHash := blobhash(_index)
  says: Blob hashes are read with the blobhash opcode.
  for:
  - evidence-1
- id: c-validate-batched
  source: '0xe37a2663cc9c119ba41572c40fab0bbb23a5402f'
  file: src/core/libraries/rollup/BlobLib.sol
  has: function validateBatchedBlob(bytes calldata _blobInput) internal view returns (bool success) {
  line: 148
  says: Batched blob opening validation function.
  for:
  - action
  - justification
  - what
- id: c-precompile
  source: '0xe37a2663cc9c119ba41572c40fab0bbb23a5402f'
  file: src/core/libraries/rollup/BlobLib.sol
  has: (success,) = address(0x0a).staticcall(_blobInput);
  line: 150
  says: Opening is checked by the KZG point-evaluation precompile.
  for:
  - evidence-2
  - what
- id: c-require-proof
  source: '0xe37a2663cc9c119ba41572c40fab0bbb23a5402f'
  file: src/core/libraries/rollup/BlobLib.sol
  has: require(success, Errors.Rollup__InvalidBlobProof(bytes32(_blobInput[0:32])));
  line: 151
  says: Epoch proof reverts if the precompile fails.
  for:
  - evidence-2
- id: c-blobhash-check
  source: '0xe37a2663cc9c119ba41572c40fab0bbb23a5402f'
  file: src/core/libraries/rollup/BlobLib.sol
  has: require(blobHash == blobHashCheck, Errors.Rollup__InvalidBlobHash(blobHash, blobHashCheck));
  line: 105
  says: Commitments must match the transaction's blob versioned hashes.
  for:
  - evidence-1
  - justification
  - what
sources:
- study: top-callers-classification
  who: Review00 (verified source of rollup versions 0, 2 and 3; Registry, GSE and portal reads; Xatu activity);
    split from the committee-attestation classification, which noted the blob opening
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
reviews: []
related: []
---

## What happens

The Rollup ties each epoch proof to its EIP-4844 blobs by a KZG point-evaluation opening. A quantum attacker who recovers the KZG ceremony trapdoor can forge that opening, so epochs finalize while the blobs lack the transaction data, locking L2 funds that need it.

## Evidence

- [validateBlobs](https://etherscan.io/address/0xe37a2663cc9c119ba41572c40fab0bbb23a5402f#code) requires each KZG commitment's versioned hash to equal the transaction's blobhash.
- [validateBatchedBlob](https://etherscan.io/address/0xe37a2663cc9c119ba41572c40fab0bbb23a5402f#code) accepts the batched blob opening if the point-evaluation precompile 0x0a succeeds.

## Reviewer notes

### Mechanism

propose -> ProposeLib -> BlobLib.validateBlobs (BlobLib.sol lines 80-124): each 48-byte KZG commitment is hashed by calculateBlobHash (lines 214-219) and must equal blobhash(i) (lines 101-105, getBlobHash line 56); commitments feed calculateBlobCommitmentsHash (lines 183-203). submitEpochRootProof -> EpochProofLib.verifyEpochRootProof -> BlobLib.validateBatchedBlob (lines 148-152) staticcalls precompile 0x0a with versioned hash, z, y, C and the quotient proof; then the Honk proof takes blobCommitmentsHash, z, y as public inputs. The KZG opening is what binds proven transaction effects to the published blobs; with the ceremony trapdoor the opening can be forged for any y, so data can be withheld while the epoch is proven. The SNARK still checks the state transition, so funds are locked, not taken. checkBlob is hardcoded true (RollupCore), with no calldata mode.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Theft of L2 funds: the SNARK still checks the state transition.
- Ruled out: Validator stake and rewards are not affected.

### History

- 2026-11-17: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
