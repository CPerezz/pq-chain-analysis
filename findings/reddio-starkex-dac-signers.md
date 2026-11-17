---
id: reddio-starkex-dac-signers
title: "Reddio StarkEx data availability committee: availability attestations are ECDSA signatures, but the exchange it serves has not updated state since 2024-09-22"
project: reddio
status: confirmed
severity: LOW
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-locked
alternative: configurable-verifier
role: core
contracts:
- address: "0x4b2bf1cb06cb636e8a14540f76c477e61d8b6669"
  implementation: null
  name: FinalizableCommittee (StarkWare_FinalizableCommittee_2022_1)
  upgradeable: "no"
  admin: members fixed except additions before finalize (not finalized, so an admin may add members and raise the threshold); consumer StarkExchange 0xb62bcd40a24985f560b5a9745d478791d8f1945c governance can register another availability verifier
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2024-09-22
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: Reddio, as governor of StarkExchange 0xb62bcd40a24985f560b5a9745d478791d8f1945c (governor address not identified); nothing is needed unless it resumes
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/reddio-starkex-dac-signers/review.json
  - evidence/reddio-starkex-dac-signers/source-excerpts.md
sources:
- by: ai-assisted
  who: Review10 (source and on-chain review)
  ref: evidence/reddio-starkex-dac-signers/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [starkex-dac-signers]
---

## Summary

This StarkWare committee contract is the data availability committee of Reddio's StarkEx exchange `0xb62bcd40…`: each state update needs 3 ECDSA signatures from members attesting that they hold the batch data (PQ-5). State transitions are STARK-proven, so a forged quorum (with the operator key) could only let through a state whose data is withheld, locking users out of the escape hatch. The exchange is not frozen, but it has had no state update since 2024-09-22; it holds $77. Rated LOW (step 1: no committee activity since 2024-09-22 and the exchange holds $77).

## Mechanism

- `verifyAvailabilityProof(claimHash, availabilityProofs)`: for each of the first `signaturesRequired` 65-byte (r, s, v) entries, `ecrecover(claimHash, v, r, s)` must be a member and addresses must be strictly increasing; then `registerFact(claimHash)` ([`source-excerpts.md`](../evidence/reddio-starkex-dac-signers/source-excerpts.md)).
- The StarkExchange's `updateState` (operator only) requires that fact from a registered availability verifier, alongside the STARK fact from SHARP. Forging attestations therefore needs the members' keys and the operator key (`0x2e1c08e4…`, which submits the committee calls); both are ECDSA keys with public signatures.
- `FinalizableCommittee`: until `finalize`, the admin can `addCommitteeMemeber` and `incrementRequiredSigners`; members cannot be removed.

## Evidence

- CHECKED (verified source, Sourcify): `Committee.sol` of `0x4b2bf1cb…` as above; `identify()` returns the version string in [`review.json`](../evidence/reddio-starkex-dac-signers/review.json).
- CHECKED (on-chain, block 26,431,780): committee `signaturesRequired()` 3; `isMember(0x0)` false; exchange `0xb62bcd40…`: implementation `0xdf2f2475…` (StarkExchange); isFrozen() false; getRegisteredAvailabilityVerifiers() = [committee]; getSequenceNumber() 1,025; governor not identified (the committee's creator and the operator are not governors); upgrade activation delay 0.
- CHECKED (Blockscout, 2026-11-17): the committee's recent transactions are all `verifyAvailabilityProof` from operator `0x2e1c08e4…`, the last on 2024-09-22; the exchange holds 0.028 ETH ($50 at $1,814.71) and $27 of priced ERC-20 tokens (USDC $21, USDT $6); NFTs: 2 RED tokens.
- CHECKED (precompile trace): 0 transactions with ecrecover in the year to 2026-03-18 (`data/agg/y1_caller.parquet`).
- NOT FOUND: no L2BEAT page for this project; member count not established.
- Not in the census's curated set before this review; created from the alltime precompile trace of StarkEx committees.

## Impact and exposure

| Contract | Upgradeable | Exchange escrow | Last active | 30-day txs |
|---|---|---|---|---|
| `0x4b2bf1cb…` FinalizableCommittee | no | $77 (StarkExchange `0xb62bcd40…`) | 2024-09-22 | 0 |

- Escrow: StarkExchange `0xb62bcd40a24985f560b5a9745d478791d8f1945c`, $77 on 2026-11-17 (ETH $50 plus priced tokens $27; USDC $21, USDT $6). The committee cannot move or lock it in the exchange's current state, so `value_usd` is left null.
- Impact: funds-locked (data withholding), and only together with the operator key; a false state cannot be proven.
- Same mechanism elsewhere: edgeX v1's committee, [starkex-dac-signers](starkex-dac-signers.md), and the other StarkEx committees reviewed on 2026-11-17 (ImmutableX, Sorare, Myria, tanX, rhino.fi, Reddio).

## Remediation

- Nothing is needed while the exchange stays in this state. If state updates resume, the governor should first register an availability verifier with post-quantum member signatures (hash-based or ML-DSA), or move data on-chain.
- The governor and operator keys are ECDSA keys themselves (PQ-12).
- No protocol change is needed.

## History

- 2026-11-17: created in review (Review10) from the alltime precompile trace (StarkEx committees missing from the curated set), verified source, on-chain reads at block 26,431,780 and Blockscout holdings. Rated LOW (step 1: no committee activity since 2024-09-22 and the exchange holds $77).
