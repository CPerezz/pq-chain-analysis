---
id: immutablex-starkex-dac-signers
title: "ImmutableX StarkEx data availability committee: availability attestations are ECDSA signatures, but the exchange it serves no longer accepts state updates"
project: immutable
status: confirmed
severity: LOW
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-locked
alternative: configurable-verifier
role: core
contracts:
- address: "0x16ba0f221664a5189cf2c1a7af0d3abfc70aa295"
  implementation: null
  name: Committee (StarkWare_Committee_2019_1)
  upgradeable: "no"
  admin: members and threshold fixed at deployment, no admin; consumer StarkExchange 0x5fdcca53617f4d2b9134b29090c87d01058e27e9 governance can register another availability verifier
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-02-26
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: Immutable, as governor of StarkExchange 0x5fdcca53617f4d2b9134b29090c87d01058e27e9 (IMXAdminMultisig 0xd2c37fc6fd89563187f3679304975655e448d192); nothing is needed unless state updates return
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431780
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/immutablex-starkex-dac-signers
sources:
- by: ai-assisted
  study: top-callers-classification
  who: Review10 (source and on-chain review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/immutablex-starkex-dac-signers/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [starkex-dac-signers]
---

## Summary

This StarkWare committee contract is the data availability committee of ImmutableX's StarkEx exchange `0x5fdcca53…`: each state update needs 5 ECDSA signatures from members attesting that they hold the batch data (PQ-5). State transitions are STARK-proven, so a forged quorum (with the operator key) could only let through a state whose data is withheld, locking users out of the escape hatch. The exchange was upgraded on 2026-05-21 to `StarkExchangeMigrationV2`, a migration implementation without `updateState` or availability-verifier registration (verified source: `migrateVaultRoot`, `migrateHoldings`, legacy `withdraw`); it holds $454k (2026-11-17), which the committee cannot move or lock in this state. Rated LOW (step 4: the consumer's implementation has no state-update path any more (read in verified source and on-chain), so the attestations release and lock nothing; the committee holds nothing).

## Mechanism

- `verifyAvailabilityProof(claimHash, availabilityProofs)`: for each of the first `signaturesRequired` 65-byte (r, s, v) entries, `ecrecover(claimHash, v, r, s)` must be a member and addresses must be strictly increasing; then `registerFact(claimHash)` ([`source-excerpts.md`](#source-excerpts-immutablex-starkex-dac-signers)).
- The StarkExchange's `updateState` (operator only) requires that fact from a registered availability verifier, alongside the STARK fact from SHARP. Forging attestations therefore needs the members' keys and the operator key (`0x9b7f7d0d…`, which submits the committee calls); both are ECDSA keys with public signatures.
- The 2019 `Committee` has no admin functions: members and threshold are fixed at deployment.

## Evidence

- CHECKED (verified source, Sourcify): `Committee.sol` of `0x16ba0f22…` as above; `identify()` returns the version string in [`review.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/immutablex-starkex-dac-signers/review.json).
- CHECKED (on-chain, block 26,431,780): committee `signaturesRequired()` 5; `isMember(0x0)` false; exchange `0x5fdcca53…`: implementation `0x273b65a7…` (StarkExchangeMigrationV2); isFrozen() false; getRegisteredAvailabilityVerifiers() reverts (function removed); proxy governor IMXAdminMultisig 0xd2c37fc6fd89563187f3679304975655e448d192 (4 of 6; proxyIsGovernor true), upgrade activation delay 14 days on-chain.
- CHECKED (Blockscout, 2026-11-17): the committee's recent transactions are all `verifyAvailabilityProof` from operator `0x9b7f7d0d…`, the last on 2026-02-26; the exchange holds 226.508 ETH ($411k at $1,814.71) and $43k of priced ERC-20 tokens (first page only; more holdings exist); NFTs: ERC-721 collections (GALZ, Gods Unchained and others).
- CHECKED (precompile trace): 3,097 transactions with ecrecover in the year to 2026-03-18 (`data/agg/y1_caller.parquet`).
- CHECKED (external, L2BEAT): DAC threshold 5/7.
- Not in the census's curated set before this review; created from the alltime precompile trace of StarkEx committees.

## Impact and exposure

| Contract | Upgradeable | Exchange escrow | Last active | 30-day txs |
|---|---|---|---|---|
| `0x16ba0f22…` Committee | no | $454k (StarkExchange `0x5fdcca53…`) | 2026-02-26 | 0 |

- Escrow: StarkExchange `0x5fdcca53617f4d2b9134b29090c87d01058e27e9`, $454k on 2026-11-17 (ETH $411k plus priced tokens $43k; first page only; more holdings exist). The committee cannot move or lock it in the exchange's current state, so `value_usd` is left null.
- Impact: funds-locked (data withholding), and only together with the operator key; a false state cannot be proven.
- Same mechanism elsewhere: edgeX v1's committee, [starkex-dac-signers](starkex-dac-signers.md), and the other StarkEx committees reviewed on 2026-11-17 (ImmutableX, Sorare, Myria, tanX, rhino.fi, Reddio).

## Remediation

- Nothing is needed while the exchange stays in this state. If state updates resume, the governor should first register an availability verifier with post-quantum member signatures (hash-based or ML-DSA), or move data on-chain.
- The governor and operator keys are ECDSA keys themselves (PQ-12).
- No protocol change is needed.

## History

- 2026-11-17: created in review (Review10) from the alltime precompile trace (StarkEx committees missing from the curated set), verified source, on-chain reads at block 26,431,780 and Blockscout holdings. Rated LOW (step 4: the consumer's implementation has no state-update path any more (read in verified source and on-chain), so the attestations release and lock nothing; the committee holds nothing).

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

