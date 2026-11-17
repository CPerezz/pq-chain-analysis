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
