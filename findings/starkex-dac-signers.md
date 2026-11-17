---
id: starkex-dac-signers
title: "edgeX v1 (StarkEx) data availability committee: availability attestations are ECDSA signatures; forging a quorum could let the operator withhold state data, but the StarkPerpetual it serves has been frozen since 2026-08-14"
project: edgex
status: confirmed
severity: LOW
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-locked
alternative: configurable-verifier
role: core
contracts:
- address: "0x23bf3dcc14680162b7f5355aabb56d31823c946e"
  implementation: null
  name: FinalizableCommittee (StarkWare)
  upgradeable: "no"
  admin: members fixed except additions before finalize (admin may add members and raise the threshold; not finalized); consumer StarkPerpetual 0xfaae2946e846133af314d1df13684c89fa7d83dd governance can register another availability verifier and is the only party that can unfreeze
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-08-14
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: edgeX, as governance of StarkPerpetual 0xfaae2946e846133af314d1df13684c89fa7d83dd (governor address not read); nothing is needed while the contract stays frozen
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/starkex-dac-signers
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review10 (source and on-chain review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/starkex-dac-signers/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [immutablex-starkex-dac-signers, sorare-starkex-dac-signers, myria-starkex-dac-signers, tanx-starkex-dac-signers, rhinofi-starkex-dac-signers, reddio-starkex-dac-signers]
---

## Summary

This StarkWare `FinalizableCommittee` is the data availability committee of edgeX v1, a StarkEx perpetuals validium: each state update needs `signaturesRequired` (2) ECDSA signatures from members attesting that they hold the batch data (PQ-5). State transitions themselves are proven with STARKs, so forged attestations cannot create a false state; with a forged quorum and the operator key, an attacker could commit a valid state whose data nobody has, locking users out of escape-hatch withdrawals. The StarkPerpetual it serves, `0xfaae2946…`, has been frozen since 2026-08-14 (`updateState` reverts `STATE_IS_FROZEN`), so the path is dead while $2.42M USDT waits for escape-hatch withdrawals that do not use the committee. Rated LOW: the path is dormant and the committee holds nothing.

## Mechanism

- `Committee.verifyAvailabilityProof(claimHash, availabilityProofs)`: for `proofIdx < signaturesRequired`, reads 65-byte (r, s, v), `ecrecover(claimHash, v, r, s)` must be a member, addresses strictly increasing; then `registerFact(claimHash)`.
- StarkPerpetual's `updateState` (operator only) requires that fact from a registered availability verifier, alongside the STARK fact from the SHARP verifier.
- `FinalizableCommittee`: until `finalize`, the admin can `addCommitteeMemeber` and `incrementRequiredSigners`; members cannot be removed.

Source excerpts: [`source-excerpts.md`](#source-excerpts-starkex-dac-signers).

## Evidence

- CHECKED (verified source, Sourcify `Committee.sol`, `FinalizableCommittee.sol`): as above.
- CHECKED (on-chain, 2026-11-17): committee `signaturesRequired()` 2, `isFinalized()` false; StarkPerpetual `getRegisteredAvailabilityVerifiers()` = [this committee], `isFrozen()` true, `updateState` eth_call reverts `STATE_IS_FROZEN`, `unFreeze` reverts `ONLY_GOVERNANCE` ([`review.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/starkex-dac-signers/review.json)).
- CHECKED (Blockscout): all recent committee calls are `verifyAvailabilityProof` from operator `0xcbe6fbf5…`, the last on 2026-08-14; StarkPerpetual holds 2,417,958 USDT.
- CHECKED (external, L2BEAT edgeX v1 page): the StarkPerpetual was frozen on 2026-08-14 after a forced withdrawal went unserved; remaining funds leave only through the escape hatch.
- CHECKED (precompile trace, last year): 48,347 transactions with ecrecover (`txs_y1`); Xatu: none 2026-10-16 to 2026-11-16 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/starkex-dac-signers/activity.json)).
- NOT READ: the StarkPerpetual governor addresses.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x23bf3dcc…` FinalizableCommittee | no | $0 | 2026-08-14 | 0 |

- The committee holds nothing. The $2.42M USDT in StarkPerpetual `0xfaae2946…` cannot be moved or locked through the committee while the contract is frozen; escape-hatch withdrawals use Merkle proofs against the last accepted state.
- Impact if the path were live: funds-locked (data withholding), and only together with the operator key, since `updateState` is operator-only.
- Other StarkEx committees, each in its own finding since this review: ImmutableX [immutablex-starkex-dac-signers](immutablex-starkex-dac-signers.md), Sorare [sorare-starkex-dac-signers](sorare-starkex-dac-signers.md), Myria [myria-starkex-dac-signers](myria-starkex-dac-signers.md), tanX [tanx-starkex-dac-signers](tanx-starkex-dac-signers.md), rhino.fi [rhinofi-starkex-dac-signers](rhinofi-starkex-dac-signers.md), Reddio [reddio-starkex-dac-signers](reddio-starkex-dac-signers.md).

## Remediation

- Nothing is needed for edgeX v1 while it stays frozen. If governance ever unfreezes it, it should first register an availability verifier with post-quantum member signatures (hash-based or ML-DSA), or move data on-chain.
- For live StarkEx instances: StarkWare's committee contract needs a post-quantum signature scheme, and each operator's governance registers the new committee.
- No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review10): MEDIUM -> LOW, step 4: the consumer StarkPerpetual is frozen (read on-chain), so no state update can use the attestations, and the committee holds nothing. Project starkware -> edgex (the operator that registered this committee); impact funds-loss -> funds-locked (validity is STARK-proven, the committee attests only data availability).
- 2026-11-17 review follow-up (Review10): the six other StarkEx committees found in the trace now have their own findings, listed in `related`.

# Source excerpts: starkex-dac-signers

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x23bf3dcc14680162b7f5355aabb56d31823c946e` — FinalizableCommittee (verified source via sourcify)

### `starkware/solidity/committee/Committee.sol`

```solidity
   73              bytes32 r = bytesToBytes32(availabilityProofs, offset);
   74              bytes32 s = bytesToBytes32(availabilityProofs, offset + 32);
   75              uint8 v = uint8(availabilityProofs[offset + 64]);
   76              offset += SIGNATURE_LENGTH;
   77              address recovered = ecrecover(claimHash, v, r, s);
   78              // Signatures should be sorted off-chain before submitting to enable cheap uniqueness
   79              // check on-chain.
   80              require(isMember[recovered], "AVAILABILITY_PROVER_NOT_IN_COMMITTEE");
   81              require(recovered > prevRecoveredAddress, "NON_SORTED_SIGNATURES");
  ...
```
