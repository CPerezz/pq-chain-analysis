---
id: sorare-starkex-dac-signers
title: "Sorare StarkEx data availability committee: availability attestations are ECDSA signatures, but the exchange it serves is frozen"
project: sorare
status: confirmed
severity: LOW
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-locked
alternative: configurable-verifier
role: core
contracts:
- address: "0x879cd57975d596004863d30c59d579ef78bbbe32"
  implementation: null
  name: Committee (StarkWare_Committee_2019_1)
  upgradeable: "no"
  admin: members and threshold fixed at deployment, no admin; consumer StarkExchange 0xf5c9f957705bea56a7e806943f98f7777b995826 governance can register another availability verifier
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-05-31
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: Sorare, as governor of StarkExchange 0xf5c9f957705bea56a7e806943f98f7777b995826; nothing is needed while it stays frozen
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/sorare-starkex-dac-signers/review.json
  - evidence/sorare-starkex-dac-signers/source-excerpts.md
sources:
- by: ai-assisted
  who: Review10 (source and on-chain review)
  ref: evidence/sorare-starkex-dac-signers/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [starkex-dac-signers]
---

## Summary

This StarkWare committee contract is the data availability committee of Sorare's StarkEx exchange `0xf5c9f957…`: each state update needs 2 ECDSA signatures from members attesting that they hold the batch data (PQ-5). State transitions are STARK-proven, so a forged quorum (with the operator key) could only let through a state whose data is withheld, locking users out of the escape hatch. The exchange is frozen: `isFrozen()` true; L2BEAT reports Sorare froze the rollup on 2026-06-01 with a governor freeze function; it holds $3.18M (2026-11-17), which the committee cannot move or lock in this state. Rated LOW (step 4: the exchange is frozen, so no state update can use the attestations, and the committee holds nothing).

## Mechanism

- `verifyAvailabilityProof(claimHash, availabilityProofs)`: for each of the first `signaturesRequired` 65-byte (r, s, v) entries, `ecrecover(claimHash, v, r, s)` must be a member and addresses must be strictly increasing; then `registerFact(claimHash)` ([`source-excerpts.md`](../evidence/sorare-starkex-dac-signers/source-excerpts.md)).
- The StarkExchange's `updateState` (operator only) requires that fact from a registered availability verifier, alongside the STARK fact from SHARP. Forging attestations therefore needs the members' keys and the operator key (`0x63881ac4…`, which submits the committee calls); both are ECDSA keys with public signatures.
- The 2019 `Committee` has no admin functions: members and threshold are fixed at deployment.

## Evidence

- CHECKED (verified source, Sourcify): `Committee.sol` of `0x879cd579…` as above; `identify()` returns the version string in [`review.json`](../evidence/sorare-starkex-dac-signers/review.json).
- CHECKED (on-chain, block 26,431,780): committee `signaturesRequired()` 2; `isMember(0x0)` false; exchange `0xf5c9f957…`: implementation `0xdf2f2475…` (StarkExchange); isFrozen() true; getRegisteredAvailabilityVerifiers() = [committee]; getSequenceNumber() 25,418; proxy governors SorareAdminMultisig 0xcc928977e4a75d25099e7da7b6fd79dac2f9fd2b (2 of 3) and EOA 0x5918481f777dbe437de249492b90affb4e655de4 (proxyIsGovernor true for both), upgrade activation delay 0.
- CHECKED (Blockscout, 2026-11-17): the committee's recent transactions are all `verifyAvailabilityProof` from operator `0x63881ac4…`, the last on 2026-05-31; the exchange holds 1747.158 ETH ($3.17M at $1,814.71) and $7k of priced ERC-20 tokens (complete first page); NFTs: ERC-721 collections (SOR, SON, SOB, SNS).
- CHECKED (precompile trace): 5,385 transactions with ecrecover in the year to 2026-03-18 (`data/agg/y1_caller.parquet`).
- CHECKED (external, L2BEAT): DAC threshold 2/4.
- Not in the census's curated set before this review; created from the alltime precompile trace of StarkEx committees.

## Impact and exposure

| Contract | Upgradeable | Exchange escrow | Last active | 30-day txs |
|---|---|---|---|---|
| `0x879cd579…` Committee | no | $3.18M (StarkExchange `0xf5c9f957…`) | 2026-05-31 | 0 |

- Escrow: StarkExchange `0xf5c9f957705bea56a7e806943f98f7777b995826`, $3.18M on 2026-11-17 (ETH $3.17M plus priced tokens $7k; complete first page). The committee cannot move or lock it in the exchange's current state, so `value_usd` is left null.
- Impact: funds-locked (data withholding), and only together with the operator key; a false state cannot be proven.
- Same mechanism elsewhere: edgeX v1's committee, [starkex-dac-signers](starkex-dac-signers.md), and the other StarkEx committees reviewed on 2026-11-17 (ImmutableX, Sorare, Myria, tanX, rhino.fi, Reddio).

## Remediation

- Nothing is needed while the exchange stays in this state. If state updates resume, the governor should first register an availability verifier with post-quantum member signatures (hash-based or ML-DSA), or move data on-chain.
- The governor and operator keys are ECDSA keys themselves (PQ-12).
- No protocol change is needed.

## History

- 2026-11-17: created in review (Review10) from the alltime precompile trace (StarkEx committees missing from the curated set), verified source, on-chain reads at block 26,431,780 and Blockscout holdings. Rated LOW (step 4: the exchange is frozen, so no state update can use the attestations, and the committee holds nothing).
