---
id: ethstorage-blob-kzg
title: "EthStorage storage contract: storage proofs open users' blobs with KZG point evaluation; with the KZG setup trapdoor a whitelisted miner can collect mining rewards (USD 321 pool) without holding the data, and the blob commitments cannot be swapped for another scheme"
project: ethstorage
status: confirmed
severity: LOW
patterns: [PQ-8]
primitives: [kzg]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xf0193d6e8fc186e77b6e63af4151db07524f6a7a"
  implementation: "0x99f5cc6ad111584c88891b4c6fff5784a46adf33"
  name: TransparentUpgradeableProxy -> EthStorageContractM2
  upgradeable: "yes"
  admin: "ProxyAdmin 0x654dd56444856e928917549263aac6f9d6a96372, owner Safe 0xa10d87502a0d8fce45610c6028f0756383649f3c (1 of 2); the Safe also holds DEFAULT_ADMIN_ROLE (miner whitelist)"
  value_usd: 321
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 94
families: []
fix:
  layer: contract-upgrade
  who_acts: "EthStorage (Safe 0xa10d87502a0d8fce45610c6028f0756383649f3c via ProxyAdmin 0x654dd56444856e928917549263aac6f9d6a96372) upgrades the contract to add a non-KZG storage path, which needs users to upload again; post-quantum data availability in the Ethereum protocol would cover blob-stored data without that migration"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/ethstorage-blob-kzg
sources:
- by: ai-assisted
  study: top-callers-classification
  who: Review15 (finding review)
  ref: findings/ethstorage-blob-kzg.md
  date: 2026-11-17
  verdict: reported
  rating: MEDIUM
related: [ethstorage-mining-groth16]
---

## Summary

EthStorage stores users' data as EIP-4844 blobs and pays whitelisted miners for proving they keep it. Each storage
proof opens the stored blob at a random point with the KZG point-evaluation precompile (PQ-8). With the KZG ceremony's
trapdoor, a miner can open any value, so it can be paid without holding users' data; the reward pool is the
contract's balance, USD 321 on 2026-11-17. The only commitment to stored data is the blob's KZG versioned hash, and the
contract has no non-blob storage path, so no admin setting removes the dependency. Rated LOW (MEDIUM at step 4: an
upgrade by the Safe can add a non-KZG storage path, with users uploading their data again; lowered at step 5: under
USD 50k exposed).

## Mechanism

- `putBlob` / `putBlobs` (`EthStorageContract.sol` 175–215) store `blobhash(i)` as the entry's `hash`; no other put
  function exists.
- `StorageContract.mine` (whitelisted `miner`, `enforceMinerRole() = true`) -> `_mine` ->
  `EthStorageContractM2.verifySamples` -> `_checkSample` (`EthStorageContractM2.sol` 76–95) ->
  `checkInclusive(hash, sampleIdx, mask ^ encodedSample, peInput)` (`EthStorageContract.sol` 132–156): for a stored
  entry it calls `_pointEvaluation` (108–124, `STATICCALL` to `0x0a`) and requires the opened point to be
  `RU_BLS^reverse(sampleIdx)`, the versioned hash to match, and the opened value to equal the decoded sample. If the
  difficulty is met, `_rewardMiner` pays the miner from the contract balance.
- With the trapdoor, the miner picks the decoded value and forges the opening; the Groth16 decoding proof
  (`ethstorage-mining-groth16`) can then be made honestly from those values, so the KZG forgery alone avoids storing
  the data.

Pattern PQ-8. Excerpt: [`source-excerpts.md`](#source-excerpts-ethstorage-blob-kzg).

## Evidence

- CHECKED (verified source, Sourcify, implementation `0x99f5…df33`): the path above; `blobhash` is the only source
  of entry hashes ([`notes.md`](#reads-review15-2026-11-17)).
- CHECKED (block 26,431,725): implementation slot `0x99f5cc6a…`; balance 0.17725 ETH; `kvEntryCount() = 3338`,
  `shardEntryBits() = 22`, `randomChecks() = 2`, `enforceMinerRole() = true`. Admin chain (ProxyAdmin, 1-of-2 Safe)
  read at block 26,431,543 (`ethstorage-mining-groth16` evidence).
- CHECKED (precompile trace, all time): no `pointEval` call from this contract; 260 mining proofs all hit empty
  entries (`hash == 0`), where `checkInclusive` needs no opening. The KZG path becomes active as the shard fills
  (3,338 of 4,194,304 entries used).
- CHECKED (Xatu, any function): 94 transactions 2026-10-16 to 2026-11-16, last 2026-11-15
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/ethstorage-blob-kzg/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xf0193d6e…` EthStorageContractM2 | yes (1-of-2 Safe) | USD 321 (held: reward pool) | 2026-11-15 | 94 |

Who can exploit it: only miners on the whitelist kept by the Safe. What is lost: the reward pool (funded by users'
storage payments) and the guarantee that users' data is kept; the data loss is not valued here. Anyone can upload
blobs, but uploading releases nothing.

## Remediation

- No fallback exists that the admin can switch to: entries are committed only by KZG versioned hashes, so existing
  data cannot be proven any other way. An upgrade by the Safe could add a non-KZG storage path (data in calldata with
  a hash-based commitment, proven with a STARK), but users would have to upload again; post-quantum blob data
  availability needs an Ethereum protocol change.
- Until then the miner whitelist limits who can cheat. The Safe owners are ECDSA EOAs and should move to post-quantum
  signers.

## History

- 2026-11-17: created in review (Review15) from the KZG opening noted in `ethstorage-mining-groth16`; verified source and on-chain state read at block 26,431,725. Rated MEDIUM (step 4 HIGH: KZG dependency with no switchable fallback; step 5: under USD 50k exposed).
- 2026-11-17 rubric correction: MEDIUM -> LOW, step 4 (HIGH -> MEDIUM): an upgrade by the Safe can add a non-KZG storage path, with users re-uploading their data (an upgrade plus a migration), then step 5 (USD 321 exposed, under USD 50k) lowers it to LOW; `fix.layer` protocol -> contract-upgrade, `protocol_change` required -> helps.

# Source excerpts: ethstorage-blob-kzg

Implementation `0x99f5cc6ad111584c88891b4c6fff5784a46adf33` (EthStorageContractM2, Sourcify), copied by Review15 on 2026-11-17.

### `contracts/EthStorageContract.sol` lines 104-156

```solidity
  104      /// @param _input The input data
  105      /// @return versionedHash_ The versioned hash
  106      /// @return x_ The x coordinate
  107      /// @return y_ The y coordinate
  108      function _pointEvaluation(bytes memory _input)
  109          internal
  110          view
  111          returns (uint256 versionedHash_, uint256 x_, uint256 y_)
  112      {
  113          assembly {
  114              versionedHash_ := mload(add(_input, 0x20))
  115              x_ := mload(add(_input, 0x40))
  116              y_ := mload(add(_input, 0x60))
  117  
  118              // Call the precompiled contract 0x0a = point evaluation, reuse scratch to get the results
  119              if iszero(staticcall(not(0), 0x0a, add(_input, 0x20), 0xc0, 0x0, 0x40)) { revert(0, 0) }
  120              // Check the results
  121              if iszero(eq(mload(0x0), FIELD_ELEMENTS_PER_BLOB)) { revert(0, 0) }
  122              if iszero(eq(mload(0x20), MODULUS_BLS)) { revert(0, 0) }
  123          }
  124      }
  125  
  126      /// @notice Check the decoded data is included in the BLOB corresponding to on-chain datahashes
  127      /// @param _dataHash The data hash
  128      /// @param _sampleIdxInKv The sample index in the KV
  129      /// @param _decodedData The decoded sample
  130      /// @param _peInput The point evaluation input
  131      /// @return The result of the check
  132      function checkInclusive(bytes32 _dataHash, uint256 _sampleIdxInKv, uint256 _decodedData, bytes memory _peInput)
  133          public
  134          view
  135          virtual
  136          returns (bool)
  137      {
  138          if (_dataHash == 0x0) {
  139              return _decodedData == 0;
  140          }
  141          // peInput includes an input point that comes from bit reversed sampleIdxInKv
  142          uint256 sampleIdxInKvRev = BinaryRelated.reverseBits(12, _sampleIdxInKv);
  143          uint256 xBls = _modExp(RU_BLS, sampleIdxInKvRev, MODULUS_BLS);
  144          (uint256 versionedHash, uint256 evalX, uint256 evalY) = _pointEvaluation(_peInput);
  145          if (evalX != xBls || bytes24(bytes32(versionedHash)) != _dataHash) {
  146              return false;
  147          }
  148  
  149          return evalY == _decodedData;
  150      }
  151  
  152      /// @notice Get the sample index
  153      /// @param _rows The sample count per shard
  154      /// @param _startShardId The start shard ID
  155      /// @param _hash0 The hash0
  156      /// @return The key index contains the sample
```

### `contracts/EthStorageContract.sol` lines 170-194

```solidity
  170      /// @notice Write a large value to KV store.  If the KV pair exists, overrides it.
  171      ///         Otherwise, will append the KV to the KV array.
  172      /// @param _key The key of the KV pair
  173      /// @param _blobIdx The index of the blob
  174      /// @param _length The length of the blob
  175      function putBlob(bytes32 _key, uint256 _blobIdx, uint256 _length) public payable virtual {
  176          bytes32 dataHash = blobhash(_blobIdx);
  177          if (dataHash == 0) {
  178              revert EthStorageContract_FailedToGetBlobHash();
  179          }
  180  
  181          bytes32[] memory keys = new bytes32[](1);
  182          keys[0] = _key;
  183          bytes32[] memory dataHashes = new bytes32[](1);
  184          dataHashes[0] = dataHash;
  185          uint256[] memory lengths = new uint256[](1);
  186          lengths[0] = _length;
  187  
  188          uint256[] memory kvIndices = _putBatchInternal(keys, dataHashes, lengths);
  189  
  190          emit PutBlob(kvIndices[0], _length, dataHash);
  191      }
  192  
  193      /// @notice Write multiple large values to KV store.
  194      /// @param _keys The keys of the KV pairs
```

### `contracts/EthStorageContractM2.sol` lines 76-95

```solidity
   76      function _checkSample(
   77          uint256 _startShardId,
   78          uint256 _rows,
   79          bytes32 _hash0,
   80          bytes32 _encodedSample,
   81          uint256 _mask,
   82          bytes calldata _inclusiveProof
   83      ) internal view returns (bytes32, uint256, uint256) {
   84          (uint256 kvIdx, uint256 sampleIdxInKv) = getSampleIdx(_rows, _startShardId, _hash0);
   85  
   86          PhyAddr memory kvInfo = _kvMap(_idxMap(kvIdx));
   87  
   88          if (!checkInclusive(kvInfo.hash, sampleIdxInKv, _mask ^ uint256(_encodedSample), _inclusiveProof)) {
   89              revert EthStorageContractM2_InvalidSamples();
   90          }
   91  
   92          _hash0 = keccak256(abi.encode(_hash0, _encodedSample));
   93          return (_hash0, kvIdx, sampleIdxInKv);
   94      }
   95  
```

# Reads (Review15, 2026-11-17)

Proxy `0xf0193d6e8fc186e77b6e63af4151db07524f6a7a`; admin reads are in
`evidence/ethstorage-mining-groth16/onchain-review.md` (block 26,431,543): ProxyAdmin
`0x654dd56444856e928917549263aac6f9d6a96372`, owner Safe `0xa10d87502a0d8fce45610c6028f0756383649f3c` (1 of 2,
both owners EOAs), Safe holds `DEFAULT_ADMIN_ROLE`.

## RPC (eth.drpc.org, block 26,431,725)

| Read | Result |
|---|---|
| EIP-1967 implementation | `0x99f5cc6ad111584c88891b4c6fff5784a46adf33` |
| ETH balance | 0.177249 ETH (USD 321 at USD 1,811.62, the `onchain.json` price) |
| `kvEntryCount()` | 3,338 |
| `shardEntryBits()` (block ~26,431,608) | 22 |
| `randomChecks()` / `sampleLenBits()` | 2 / 12 |
| `enforceMinerRole()` | true |

## Source (Sourcify, implementation above)

- Data enters only through `putBlob` / `putBlobs` (`EthStorageContract.sol` 175–215), which store
  `blobhash(i)` (the EIP-4844 versioned hash of a KZG commitment) as the entry's `hash`. There is no calldata put
  path in the implementation.
- `checkInclusive` (132–156): for an entry with `hash != 0`, calls `_pointEvaluation` (108–124, `STATICCALL` to
  `0x0a`) and accepts the sample if the opened value equals `mask ^ encodedSample`; for `hash == 0` it requires the
  decoded value to be 0 and calls no precompile.
- Called from `EthStorageContractM2._checkSample` (76–95) inside `verifySamples`, from `mine` (whitelisted miners
  only), which pays `minerReward` from the contract balance.

## Precompile trace (`data/agg/alltime_caller.parquet`)

Caller `0xf0193d6e…`, all time: `ecmul` 1,560, `ecadd` 1,560, `modexp` 520, `ecpairing` 260 (blocks
23,335,287–24,683,694). No `pointEval` row: every sample so far fell on an empty entry.
