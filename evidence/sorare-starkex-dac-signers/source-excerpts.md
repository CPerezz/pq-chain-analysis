# Source excerpts: sorare-starkex-dac-signers

Committee `0x879cd57975d596004863d30c59d579ef78bbbe32` — verified source via Sourcify, read 2026-11-17 by Review10.

### `Committee.sol` (Sourcify, 0x879cd57975d596004863d30c59d579ef78bbbe32)

```solidity
   65      function verifyAvailabilityProof(
   66          bytes32 claimHash,
   67          bytes calldata availabilityProofs
   68      )
   69          external override
   70      {
   71          require(
   72              availabilityProofs.length >= signaturesRequired * SIGNATURE_LENGTH,
   73              "INVALID_AVAILABILITY_PROOF_LENGTH");
   74  
   75          uint256 offset = 0;
   76          address prevRecoveredAddress = address(0);
   77          for (uint256 proofIdx = 0; proofIdx < signaturesRequired; proofIdx++) {
   78              bytes32 r = bytesToBytes32(availabilityProofs, offset);
   79              bytes32 s = bytesToBytes32(availabilityProofs, offset + 32);
   80              uint8 v = uint8(availabilityProofs[offset + 64]);
   81              offset += SIGNATURE_LENGTH;
   82              address recovered = ecrecover(
   83                  claimHash,
   84                  v,
   85                  r,
   86                  s
   87              );
   88              // Signatures should be sorted off-chain before submitting to enable cheap uniqueness
   89              // check on-chain.
   90              require(isMember[recovered], "AVAILABILITY_PROVER_NOT_IN_COMMITTEE");
   91              require(recovered > prevRecoveredAddress, "NON_SORTED_SIGNATURES");
   92              prevRecoveredAddress = recovered;
   93          }
   94          registerFact(claimHash);
   95      }
   96  
   97      function bytesToBytes32(bytes memory array, uint256 offset)
   98          private pure
```

