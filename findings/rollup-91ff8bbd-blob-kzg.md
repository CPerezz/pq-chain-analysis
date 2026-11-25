---
id: rollup-91ff8bbd-blob-kzg
format: 2
title: Aztec Rollup v2 trusts KZG blob openings a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Epoch proofs rest on KZG openings with no calldata mode; only a governance vote for a new rollup
  version fixes it.
category: quantum-exposure
pattern: PQ-8
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34'
  name: Rollup
  project: aztec
  code: verified
  code_url: https://etherscan.io/address/0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34#code
  copies: 1
  admin: '0x1102471eb3378fee427121c9efcea452e4b6b75e'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 186242
impact: funds-locked
action: Register, by governance vote, a rollup version that publishes data via calldata or a hash-committed scheme,
  and move portals to it.
evidence_level: source
checks:
- id: c1
  source: '0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34'
  file: src/core/libraries/rollup/BlobLib.sol
  line: 56
  has: blobHash := blobhash(_index)
  says: Blob hash is read with the blobhash opcode.
  for:
  - evidence-1
- id: c-blobhash-eq
  source: '0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34'
  file: src/core/libraries/rollup/BlobLib.sol
  has: require(blobHash == blobHashCheck, Errors.Rollup__InvalidBlobHash(blobHash, blobHashCheck));
  line: 105
  says: Commitment must match the transaction's blob versioned hash.
  for:
  - evidence-1
  - what
- id: c-eval
  source: '0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34'
  file: src/core/libraries/rollup/BlobLib.sol
  has: (success,) = address(0x0a).staticcall(_blobInput);
  line: 149
  says: Batched blob opening is checked by the KZG point-evaluation precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c-validate
  source: '0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34'
  file: src/core/libraries/rollup/BlobLib.sol
  has: require(numBlobs > 0, Errors.Rollup__NoBlobsInCheckpoint());
  line: 88
  says: Every checkpoint must carry at least one blob.
  for:
  - justification
- id: c-checkblob-doc
  source: '0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34'
  file: src/core/libraries/rollup/BlobLib.sol
  has: Hardcoded to true (See RollupCore.sol -> checkBlob)
  line: 70
  says: Blob checking is hardcoded on; no alternative data mode.
  for:
  - action
  - justification
- id: c-doc-match
  source: '0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34'
  file: src/core/libraries/rollup/BlobLib.sol
  has: we know that the data in each blob of the epoch corresponds to the tx effects of all our proven txs in the
    epoch.
  line: 138
  says: The opening is what links proven tx effects to published blob data.
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

The rollup takes checkpoint data in EIP-4844 blobs and ties epoch proofs to them by a KZG opening checked by the 0x0a precompile. A quantum attacker with the KZG ceremony trapdoor can forge that opening, proving an epoch whose data is withheld and locking L2 funds.

## Evidence

- [validateBlobs](https://etherscan.io/address/0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34#code) requires each KZG commitment's versioned hash to equal the transaction's blobhash.
- [validateBatchedBlob](https://etherscan.io/address/0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34#code) accepts the batched blob opening by calling the point-evaluation precompile.

## Reviewer notes

### Mechanism

propose -> ProposeLib -> BlobLib.validateBlobs (BlobLib.sol lines 80-123): for each 48-byte commitment, calculateBlobHash must equal getBlobHash(i) (blobhash opcode, line 56) when _checkBlob is set (lines 101-105); _checkBlob is hardcoded true per line 70. Commitments are accumulated into blobCommitmentsHash (calculateBlobCommitmentsHash, lines 177-193). submitEpochRootProof -> EpochProofLib.verifyEpochRootProof -> BlobLib.validateBatchedBlob (lines 147-151) staticcalls precompile 0x0a with versioned hash, z, y, C and the proof; the Honk proof takes blobCommitmentsHash, z, y as public inputs. With the trapdoor, an opening of C at z to any y passes, so the proven tx effects need not match published blob data. The SNARK still checks the state transition, so funds are locked rather than stolen.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Theft of funds: the epoch SNARK still verifies the state transition.
- Ruled out: Validator stake and rewards are not affected.

### History

- 2026-11-17: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
