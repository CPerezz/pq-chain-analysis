---
id: myria-starkex-dac-signers
title: "Myria StarkEx data availability committee: availability attestations are ECDSA signatures, but the exchange it serves is frozen"
project: myria
status: confirmed
severity: LOW
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-locked
alternative: configurable-verifier
role: core
contracts:
- address: "0x1e601435e181423e7a8430813d7500012a6169cb"
  implementation: null
  name: Committee (StarkWare_Committee_2019_1)
  upgradeable: "no"
  admin: members and threshold fixed at deployment, no admin; consumer StarkExchange 0x3071be11f9e92a9eb28f305e1fa033cd102714e7 governance can register another availability verifier
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-05-01
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: Myria, as governor of StarkExchange 0x3071be11f9e92a9eb28f305e1fa033cd102714e7 (EOA 0xc49ec6bb817e17a9ca5b738ca330db403cc74245); nothing is needed while it stays frozen
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431780
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/myria-starkex-dac-signers
sources:
- by: ai-assisted
  study: top-callers-classification
  who: Review10 (source and on-chain review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/myria-starkex-dac-signers/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [starkex-dac-signers]
---

## Summary

This StarkWare committee contract is the data availability committee of Myria's StarkEx exchange `0x3071be11…`: each state update needs 2 ECDSA signatures from members attesting that they hold the batch data (PQ-5). State transitions are STARK-proven, so a forged quorum (with the operator key) could only let through a state whose data is withheld, locking users out of the escape hatch. The exchange is frozen: `isFrozen()` true (freeze date not established); it holds $125k (2026-11-17), which the committee cannot move or lock in this state. Rated LOW (step 4: the exchange is frozen, so no state update can use the attestations, and the committee holds nothing).

## Mechanism

- `verifyAvailabilityProof(claimHash, availabilityProofs)`: for each of the first `signaturesRequired` 65-byte (r, s, v) entries, `ecrecover(claimHash, v, r, s)` must be a member and addresses must be strictly increasing; then `registerFact(claimHash)` ([`source-excerpts.md`](#source-excerpts-myria-starkex-dac-signers)).
- The StarkExchange's `updateState` (operator only) requires that fact from a registered availability verifier, alongside the STARK fact from SHARP. Forging attestations therefore needs the members' keys and the operator key (`0xe997ece8…`, which submits the committee calls); both are ECDSA keys with public signatures.
- The 2019 `Committee` has no admin functions: members and threshold are fixed at deployment.

## Evidence

- CHECKED (verified source, Sourcify): `Committee.sol` of `0x1e601435…` as above; `identify()` returns the version string in [`review.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/myria-starkex-dac-signers/review.json).
- CHECKED (on-chain, block 26,431,780): committee `signaturesRequired()` 2; `isMember(0x0)` false; exchange `0x3071be11…`: implementation `0xdf2f2475…` (StarkExchange); isFrozen() true; getRegisteredAvailabilityVerifiers() = [committee]; getSequenceNumber() 8,409; governor EOA 0xc49ec6bb817e17a9ca5b738ca330db403cc74245 (mainIsGovernor and proxyIsGovernor true), upgrade activation delay 14 days on-chain.
- CHECKED (Blockscout, 2026-11-17): the committee's recent transactions are all `verifyAvailabilityProof` from operator `0xe997ece8…`, the last on 2026-05-01; the exchange holds 43.569 ETH ($79k at $1,814.71) and $46k of priced ERC-20 tokens (complete first page; MYRIA $41.7k, JASMY $3.3k, USDT $0.5k); NFTs: none listed.
- CHECKED (precompile trace): 1,970 transactions with ecrecover in the year to 2026-03-18 (`data/agg/y1_caller.parquet`).
- CHECKED (external, L2BEAT): DAC threshold 2/5.
- Not in the census's curated set before this review; created from the alltime precompile trace of StarkEx committees.

## Impact and exposure

| Contract | Upgradeable | Exchange escrow | Last active | 30-day txs |
|---|---|---|---|---|
| `0x1e601435…` Committee | no | $125k (StarkExchange `0x3071be11…`) | 2026-05-01 | 0 |

- Escrow: StarkExchange `0x3071be11f9e92a9eb28f305e1fa033cd102714e7`, $125k on 2026-11-17 (ETH $79k plus priced tokens $46k; complete first page; MYRIA $41.7k, JASMY $3.3k, USDT $0.5k). The committee cannot move or lock it in the exchange's current state, so `value_usd` is left null.
- Impact: funds-locked (data withholding), and only together with the operator key; a false state cannot be proven.
- Same mechanism elsewhere: edgeX v1's committee, [starkex-dac-signers](starkex-dac-signers.md), and the other StarkEx committees reviewed on 2026-11-17 (ImmutableX, Sorare, Myria, tanX, rhino.fi, Reddio).

## Remediation

- Nothing is needed while the exchange stays in this state. If state updates resume, the governor should first register an availability verifier with post-quantum member signatures (hash-based or ML-DSA), or move data on-chain.
- The governor and operator keys are ECDSA keys themselves (PQ-12).
- No protocol change is needed.

## History

- 2026-11-17: created in review (Review10) from the alltime precompile trace (StarkEx committees missing from the curated set), verified source, on-chain reads at block 26,431,780 and Blockscout holdings. Rated LOW (step 4: the exchange is frozen, so no state update can use the attestations, and the committee holds nothing).

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

