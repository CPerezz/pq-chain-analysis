# Source excerpts: myria-starkex-dac-signers

Committee `0x1e601435e181423e7a8430813d7500012a6169cb` — verified source via Sourcify, read 2026-11-17 by Review10.

### `Committee.sol` (Sourcify, 0x1e601435e181423e7a8430813d7500012a6169cb)

```solidity
   60      function verifyAvailabilityProof(bytes32 claimHash, bytes calldata availabilityProofs)
   61          external
   62          override
   63      {
   64          require(
   65              availabilityProofs.length >= signaturesRequired * SIGNATURE_LENGTH,
   66              "INVALID_AVAILABILITY_PROOF_LENGTH"
   67          );
   68  
   69          uint256 offset = 0;
   70          address prevRecoveredAddress = address(0);
   71          for (uint256 proofIdx = 0; proofIdx < signaturesRequired; proofIdx++) {
   72              bytes32 r = bytesToBytes32(availabilityProofs, offset);
   73              bytes32 s = bytesToBytes32(availabilityProofs, offset + 32);
   74              uint8 v = uint8(availabilityProofs[offset + 64]);
   75              offset += SIGNATURE_LENGTH;
   76              address recovered = ecrecover(claimHash, v, r, s);
   77              // Signatures should be sorted off-chain before submitting to enable cheap uniqueness
   78              // check on-chain.
   79              require(isMember[recovered], "AVAILABILITY_PROVER_NOT_IN_COMMITTEE");
   80              require(recovered > prevRecoveredAddress, "NON_SORTED_SIGNATURES");
   81              prevRecoveredAddress = recovered;
   82          }
   83          registerFact(claimHash);
   84      }
   85  
   86      function bytesToBytes32(bytes memory array, uint256 offset)
   87          private
   88          pure
   89          returns (bytes32 result)
   90      {
   91          // Arrays are prefixed by a 256 bit length parameter.
   92          uint256 actualOffset = offset + 32;
   93  
```

