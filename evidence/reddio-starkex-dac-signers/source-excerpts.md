# Source excerpts: reddio-starkex-dac-signers

Committee `0x4b2bf1cb06cb636e8a14540f76c477e61d8b6669` — verified source via Sourcify, read 2026-11-17 by Review10.

### `Committee.sol` (Sourcify, 0x4b2bf1cb06cb636e8a14540f76c477e61d8b6669)

```solidity
   61      function verifyAvailabilityProof(bytes32 claimHash, bytes calldata availabilityProofs)
   62          external
   63          override
   64      {
   65          require(
   66              availabilityProofs.length >= signaturesRequired * SIGNATURE_LENGTH,
   67              "INVALID_AVAILABILITY_PROOF_LENGTH"
   68          );
   69  
   70          uint256 offset = 0;
   71          address prevRecoveredAddress = address(0);
   72          for (uint256 proofIdx = 0; proofIdx < signaturesRequired; proofIdx++) {
   73              bytes32 r = bytesToBytes32(availabilityProofs, offset);
   74              bytes32 s = bytesToBytes32(availabilityProofs, offset + 32);
   75              uint8 v = uint8(availabilityProofs[offset + 64]);
   76              offset += SIGNATURE_LENGTH;
   77              address recovered = ecrecover(claimHash, v, r, s);
   78              // Signatures should be sorted off-chain before submitting to enable cheap uniqueness
   79              // check on-chain.
   80              require(isMember[recovered], "AVAILABILITY_PROVER_NOT_IN_COMMITTEE");
   81              require(recovered > prevRecoveredAddress, "NON_SORTED_SIGNATURES");
   82              prevRecoveredAddress = recovered;
   83          }
   84          registerFact(claimHash);
   85      }
   86  
   87      function bytesToBytes32(bytes memory array, uint256 offset)
   88          private
   89          pure
   90          returns (bytes32 result)
   91      {
   92          // Arrays are prefixed by a 256 bit length parameter.
   93          uint256 actualOffset = offset + 32;
   94  
```

