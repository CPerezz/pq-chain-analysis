---
id: tanx-starkex-dac-signers
title: "tanX (ex-Brine) StarkEx data availability committee: availability attestations are 2 ECDSA signatures; forging them with the operator key would let a state with withheld data through, locking the exchange's $247k"
project: tanx
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-locked
alternative: configurable-verifier
role: core
contracts:
- address: "0x4f8b2dd49d958b6ac3e5f4705bf1a9ada5bc4446"
  implementation: null
  name: FinalizableCommittee (StarkWare_FinalizableCommittee_2022_1)
  upgradeable: "no"
  admin: members fixed except additions before finalize (not finalized, so an admin may add members and raise the threshold); consumer StarkExchange 0x1390f521a79babe99b69b37154d63d431da27a07 governance can register another availability verifier
  value_usd: 247183
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-01-28
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: tanX, as governor of StarkExchange 0x1390f521a79babe99b69b37154d63d431da27a07 (EOA 0x303775491494a08b07365938787274f742a81f63), which deploys and registers a post-quantum availability verifier or retires the exchange
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431780
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tanx-starkex-dac-signers
sources:
- by: ai-assisted
  study: top-callers-classification
  who: Review10 (source and on-chain review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tanx-starkex-dac-signers/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [starkex-dac-signers]
---

## Summary

This StarkWare committee contract is the data availability committee of tanX (ex-Brine)'s StarkEx exchange `0x1390f521…`: each state update needs 2 ECDSA signatures from members attesting that they hold the batch data (PQ-5). State transitions are STARK-proven, so forged attestations cannot create a false balance; with a forged quorum and the operator key, an attacker could commit a valid state whose data nobody has, and users could no longer build the Merkle proofs the escape hatch needs. The exchange is not frozen and holds $247k (2026-11-17); the last attested update was on 2026-01-28. Rated MEDIUM (step 4: the committee is immutable, and the fix is a new post-quantum availability verifier that the exchange's governor EOA registers; $247k is above the step-5 threshold).

## Mechanism

- `verifyAvailabilityProof(claimHash, availabilityProofs)`: for each of the first `signaturesRequired` 65-byte (r, s, v) entries, `ecrecover(claimHash, v, r, s)` must be a member and addresses must be strictly increasing; then `registerFact(claimHash)` ([`source-excerpts.md`](#source-excerpts-tanx-starkex-dac-signers)).
- The StarkExchange's `updateState` (operator only) requires that fact from a registered availability verifier, alongside the STARK fact from SHARP. Forging attestations therefore needs the members' keys and the operator key (`0xc3a27f45…`, which submits the committee calls); both are ECDSA keys with public signatures.
- `FinalizableCommittee`: until `finalize`, the admin can `addCommitteeMemeber` and `incrementRequiredSigners`; members cannot be removed.

## Evidence

- CHECKED (verified source, Sourcify): `Committee.sol` of `0x4f8b2dd4…` as above; `identify()` returns the version string in [`review.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tanx-starkex-dac-signers/review.json).
- CHECKED (on-chain, block 26,431,780): committee `signaturesRequired()` 2; `isMember(0x0)` false; exchange `0x1390f521…`: implementation `0xdf2f2475…` (StarkExchange); isFrozen() false; getRegisteredAvailabilityVerifiers() = [committee]; getSequenceNumber() 12,651; isOperator(0xc3a27f45…) true; governor EOA 0x303775491494a08b07365938787274f742a81f63 (mainIsGovernor and proxyIsGovernor true), upgrade activation delay 0.
- CHECKED (Blockscout, 2026-11-17): the committee's recent transactions are all `verifyAvailabilityProof` from operator `0xc3a27f45…`, the last on 2026-01-28; the exchange holds 14.609 ETH ($27k at $1,814.71) and $221k of priced ERC-20 tokens (complete first page; USDC $186.3k, USDT $21.4k, WBTC $12.1k); NFTs: none listed.
- CHECKED (precompile trace): 4,085 transactions with ecrecover in the year to 2026-03-18 (`data/agg/y1_caller.parquet`).
- CHECKED (external, L2BEAT): DAC threshold 2/4.
- Not in the census's curated set before this review; created from the alltime precompile trace of StarkEx committees.

## Impact and exposure

| Contract | Upgradeable | Exchange escrow | Last active | 30-day txs |
|---|---|---|---|---|
| `0x4f8b2dd4…` FinalizableCommittee | no | $247k (StarkExchange `0x1390f521…`) | 2026-01-28 | 0 |

- Escrow: StarkExchange `0x1390f521a79babe99b69b37154d63d431da27a07`, $247k on 2026-11-17 (ETH $27k plus priced tokens $221k; complete first page; USDC $186.3k, USDT $21.4k, WBTC $12.1k). This is what forged attestations could lock (`value_usd`, basis escrow).
- Impact: funds-locked (data withholding), and only together with the operator key; a false state cannot be proven.
- Same mechanism elsewhere: edgeX v1's committee, [starkex-dac-signers](starkex-dac-signers.md), and the other StarkEx committees reviewed on 2026-11-17 (ImmutableX, Sorare, Myria, tanX, rhino.fi, Reddio).

## Remediation

- The governor deploys an availability verifier with post-quantum member signatures (hash-based or ML-DSA, e.g. through ERC-7913 verifiers) or moves data on-chain, and registers it on the exchange; the old committee is then unregistered. Freezing or retiring the exchange also removes the path.
- The governor and operator keys are ECDSA keys themselves (PQ-12).
- No protocol change is needed.

## History

- 2026-11-17: created in review (Review10) from the alltime precompile trace (StarkEx committees missing from the curated set), verified source, on-chain reads at block 26,431,780 and Blockscout holdings. Rated MEDIUM (step 4: the committee is immutable, and the fix is a new post-quantum availability verifier that the exchange's governor EOA registers; $247k is above the step-5 threshold).

# Source excerpts: tanx-starkex-dac-signers

Committee `0x4f8b2dd49d958b6ac3e5f4705bf1a9ada5bc4446` — verified source via Sourcify, read 2026-11-17 by Review10.

### `Committee.sol` (Sourcify, 0x4f8b2dd49d958b6ac3e5f4705bf1a9ada5bc4446)

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

