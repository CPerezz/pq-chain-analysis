---
id: rollup-603bb2c0-blob-kzg
format: 2
title: Aztec Rollup v0 trusts KZG blob openings a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged KZG openings let epochs finalize without published data; only a new rollup version via governance
  fixes it.
category: quantum-exposure
pattern: PQ-8
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x603bb2c05d474794ea97805e8de69bccfb3bca12'
  name: Rollup
  project: aztec
  code: verified
  code_url: https://etherscan.io/address/0x603bb2c05d474794ea97805e8de69bccfb3bca12#code
  copies: 1
  admin: '0x1102471eb3378fee427121c9efcea452e4b6b75e'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 112
impact: funds-locked
action: Register, through Aztec Governance, a rollup version that publishes data via calldata or a hash-committed
  scheme.
evidence_level: source
checks:
- id: c1
  source: '0x603bb2c05d474794ea97805e8de69bccfb3bca12'
  file: lib/l1-contracts/src/core/libraries/rollup/BlobLib.sol
  line: 56
  has: blobHash := blobhash(_index)
  says: Reads the EIP-4844 blob hash with the blobhash opcode.
  for:
  - evidence-1
  - what
- id: c-validate-blobs
  source: '0x603bb2c05d474794ea97805e8de69bccfb3bca12'
  file: lib/l1-contracts/src/core/libraries/rollup/BlobLib.sol
  has: function validateBlobs(bytes calldata _blobsInput, bool _checkBlob)
  line: 80
  says: Blob validation exists and every block must carry blobs.
  for:
  - action
  - justification
- id: c-blobcheck
  source: '0x603bb2c05d474794ea97805e8de69bccfb3bca12'
  file: lib/l1-contracts/src/core/libraries/rollup/BlobLib.sol
  has: require(blobHash == blobHashCheck, Errors.Rollup__InvalidBlobHash(blobHash, blobHashCheck));
  line: 105
  says: Commitment's versioned hash must match the transaction's blob hash.
  for:
  - evidence-1
  - what
- id: c-pointeval
  source: '0x603bb2c05d474794ea97805e8de69bccfb3bca12'
  file: lib/l1-contracts/src/core/libraries/rollup/BlobLib.sol
  has: (success,) = address(0x0a).staticcall(_blobInput);
  line: 149
  says: Batched blob opening is verified by the KZG point-evaluation precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c-comment-txeffects
  source: '0x603bb2c05d474794ea97805e8de69bccfb3bca12'
  file: lib/l1-contracts/src/core/libraries/rollup/BlobLib.sol
  has: we know that the data in each blob of the epoch corresponds to the tx effects of all our proven txs in the
    epoch.
  line: 138
  says: The opening is what ties proven tx effects to published blob data.
  for:
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

This Aztec rollup checks each block's KZG blob commitments against the EIP-4844 blob hashes. Epoch proofs are tied to those blobs by a KZG opening checked by the point-evaluation precompile. A quantum attacker with the ceremony trapdoor can prove an epoch whose blobs lack the data, locking L2 funds.

## Evidence

- [validateBlobs](https://etherscan.io/address/0x603bb2c05d474794ea97805e8de69bccfb3bca12#code) requires each commitment's versioned hash to equal blobhash(i).
- [validateBatchedBlob](https://etherscan.io/address/0x603bb2c05d474794ea97805e8de69bccfb3bca12#code) relies on a staticcall to the point-evaluation precompile 0x0a.

## Reviewer notes

### Mechanism

Rollup.propose -> ProposeLib -> BlobLib.validateBlobs (BlobLib.sol lines 80-123): for each 48-byte commitment, calculateBlobHash (lines 204-209) must equal blobhash(i) (line 56, check at line 105 when _checkBlob is true; checkBlob is hardcoded true per line 70 comment). Commitments are accumulated into blobCommitmentsHash (calculateBlobCommitmentsHash, lines 177-193). At epoch proof, BlobLib.validateBatchedBlob (lines 147-151) staticcalls the point-evaluation precompile 0x0a with the batched commitment C, z, y and the KZG proof; z, y and blobCommitmentsHash are public inputs to the root rollup proof. With the KZG trapdoor, an opening for any y can be forged, so the proven tx effects need not be the published blob data. The SNARK still enforces a valid state transition, so funds are locked rather than stolen. This version is halted per kev's finding.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Theft of funds: the epoch SNARK still checks the state transition.
- Ruled out: Validator stake and rewards are not affected.

### History

- 2026-11-17: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
