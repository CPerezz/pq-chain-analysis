---
id: ethstoragecontractm2-f0193d6e-blob-kzg
format: 2
title: EthStorage accepts KZG storage proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Stored data is committed only by KZG blob hashes; an upgrade adding a non-KZG path plus re-uploads
  fixes it, so MEDIUM.
category: quantum-exposure
pattern: PQ-8
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf0193d6e8fc186e77b6e63af4151db07524f6a7a'
  name: EthStorageContractM2
  project: ethstorage
  code: verified
  code_url: https://etherscan.io/address/0x99f5cc6ad111584c88891b4c6fff5784a46adf33#code
  proxy_of: '0x99f5cc6ad111584c88891b4c6fff5784a46adf33'
  copies: 1
  upgradeable: 'yes'
  admin: '0x654dd56444856e928917549263aac6f9d6a96372'
value:
  usd: 314
  basis: held
activity:
  txs_90d: 643
impact: funds-loss
action: Upgrade to add a non-KZG storage path, such as calldata with a hash commitment proven by a STARK, and have
  users re-upload.
evidence_level: source
checks:
- id: c2
  source: '0x99f5cc6ad111584c88891b4c6fff5784a46adf33'
  file: contracts/EthStorageContract.sol
  line: 119
  has: if iszero(staticcall(not(0), 0x0a, add(_input, 0x20), 0xc0, 0x0, 0x40)) { revert(0, 0) }
  says: _pointEvaluation staticcalls the KZG point-evaluation precompile 0x0a
  for:
  - evidence-2
  - justification
  - what
- id: c3
  source: '0x99f5cc6ad111584c88891b4c6fff5784a46adf33'
  file: contracts/EthStorageContract.sol
  line: 144
  has: (uint256 versionedHash, uint256 evalX, uint256 evalY) = _pointEvaluation(_peInput);
  says: checkInclusive opens the blob through _pointEvaluation
  for:
  - what
- id: c4
  source: '0x99f5cc6ad111584c88891b4c6fff5784a46adf33'
  file: contracts/EthStorageContract.sol
  line: 176
  has: bytes32 dataHash = blobhash(_blobIdx);
  says: putBlob takes the entry hash from blobhash
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c5
  source: '0x99f5cc6ad111584c88891b4c6fff5784a46adf33'
  file: contracts/EthStorageContract.sol
  line: 209
  has: dataHashes[i] = blobhash(_blobIdxs[i]);
  says: putBlobs takes entry hashes from blobhash
  for:
  - action
  - justification
  - what
- id: c9
  source: '0x99f5cc6ad111584c88891b4c6fff5784a46adf33'
  file: contracts/EthStorageContract.sol
  has: return evalY == _decodedData;
  line: 149
  says: the inclusion check passes when the KZG-opened value equals the decoded sample
  for:
  - evidence-3
  - what
sources:
- study: top-callers-classification
  who: Review15 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: MEDIUM
reviews: []
related: []
---

## What happens

The contract keys users' blobs by their KZG versioned hash. Mining proofs open stored blobs with the KZG precompile. With the setup trapdoor, a whitelisted miner forges openings and is paid without the data.

## Evidence

- [putBlob](https://etherscan.io/address/0x99f5cc6ad111584c88891b4c6fff5784a46adf33#code) records the blob's versioned hash as the entry's data hash.
- [_pointEvaluation](https://etherscan.io/address/0x99f5cc6ad111584c88891b4c6fff5784a46adf33#code) calls the 0x0a KZG point-evaluation precompile.
- [checkInclusive](https://etherscan.io/address/0x99f5cc6ad111584c88891b4c6fff5784a46adf33#code) accepts a sample when the opened value equals the decoded data.

## Reviewer notes

### Mechanism

putBlob (line 176) and putBlobs (line 209) store blobhash() as each entry's hash. EthStorageContractM2.verifySamples calls _checkSample (line 88), which calls checkInclusive(kvInfo.hash, sampleIdxInKv, mask ^ encodedSample, proof). For a non-empty entry, checkInclusive computes x = RU_BLS^reverse(sampleIdx) and calls _pointEvaluation (line 144). That function makes a STATICCALL to precompile 0x0a (line 119). checkInclusive then requires evalX == x and a versioned hash matching the stored hash (line 145), and returns evalY == decodedData (line 149). With the KZG trapdoor, a miner can produce an opening for any chosen y. The Groth16 decode proof can then be generated honestly from those values, so the miner passes without storing the data and is paid from the contract balance.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Empty entries (hash 0) need no KZG opening.
- Ruled out: Uploading blobs releases no funds.

### History

- 2026-11-17: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
