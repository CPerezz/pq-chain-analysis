# Source excerpts: immutablex-starkex-dac-signers

Committee `0x16ba0f221664a5189cf2c1a7af0d3abfc70aa295` — verified source via Sourcify, read 2026-11-17 by Review10.

### `Committee.sol` (Sourcify, 0x16ba0f221664a5189cf2c1a7af0d3abfc70aa295)

```solidity
   63      function verifyAvailabilityProof(
   64          bytes32 claimHash,
   65          bytes calldata availabilityProofs
   66      )
   67          external
   68      {
   69          require(
   70              availabilityProofs.length >= signaturesRequired * SIGNATURE_LENGTH,
   71              "INVALID_AVAILABILITY_PROOF_LENGTH");
   72  
   73          uint256 offset = 0;
   74          address prevRecoveredAddress = address(0);
   75          for (uint256 proofIdx = 0; proofIdx < signaturesRequired; proofIdx++) {
   76              bytes32 r = bytesToBytes32(availabilityProofs, offset);
   77              bytes32 s = bytesToBytes32(availabilityProofs, offset + 32);
   78              uint8 v = uint8(availabilityProofs[offset + 64]);
   79              offset += SIGNATURE_LENGTH;
   80              address recovered = ecrecover(
   81                  claimHash,
   82                  v,
   83                  r,
   84                  s
   85              );
   86              // Signatures should be sorted off-chain before submitting to enable cheap uniqueness
   87              // check on-chain.
   88              require(isMember[recovered], "AVAILABILITY_PROVER_NOT_IN_COMMITTEE");
   89              require(recovered > prevRecoveredAddress, "NON_SORTED_SIGNATURES");
   90              prevRecoveredAddress = recovered;
   91          }
   92          registerFact(claimHash);
   93      }
   94  
   95      function bytesToBytes32(bytes memory array, uint256 offset)
   96          private pure
```

