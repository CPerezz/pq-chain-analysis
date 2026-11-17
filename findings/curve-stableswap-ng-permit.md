---
id: curve-stableswap-ng-permit
title: "Curve stableswap-ng USD0/USD0++ pool (0x1d08e7ad): LP-token permit passes only 65 bytes to ERC-1271, so post-quantum accounts cannot use it; nothing forgeable"
project: curve
status: confirmed
severity: LOW
patterns: [PQ-3]
primitives: [ecrecover]
trigger: none
impact: liveness
alternative: alternative-exists
role: auxiliary
contracts:
- address: "0x1d08e7adc263cfc70b1babe6dc5bb339c16eec52"
  implementation: null
  name: CurveStableSwapNG (USD0/USD0++ pool and LP token)
  upgradeable: "no"
  admin: "factory 0x6a8cbed756804b16e05e741edabd5cb544ae21bf admin 0xeda0108d5bb8cde2ba4a59e22f3ed5d211c77187: A, fee and oracle parameters only; permit cannot change"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 202
families: []
fix:
  layer: new-deployment
  who_acts: "Curve (stableswap-ng factory 0x6a8cbed756804b16e05e741edabd5cb544ae21bf, admin 0xeda0108d5bb8cde2ba4a59e22f3ed5d211c77187) ships a pool implementation whose permit takes bytes signatures; LPs use approve() meanwhile"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/curve-stableswap-ng-permit/classification.jsonl
  - evidence/curve-stableswap-ng-permit/onchain.json
  - evidence/curve-stableswap-ng-permit/activity.json
  - evidence/curve-stableswap-ng-permit/source-excerpts.md
  - evidence/curve-stableswap-ng-permit/review-notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review17 (Sourcify Vyper source and on-chain reads)
  ref: evidence/curve-stableswap-ng-permit/review-notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

The pool's LP token `permit` checks account code first: contract owners go to ERC-1271, code-less owners to
`ecrecover`. But the ERC-1271 call carries only a 65-byte `(r, s, v)` signature (PQ-3), so a post-quantum account
cannot sign an LP permit, while nothing is forgeable beyond each address's own key. Holders can still use `approve()`,
and the permit is an auxiliary feature of a swap pool. Rated LOW (step 4: auxiliary feature through which nothing can
be taken); the earlier NONE did not account for the 65-byte limit.

## Mechanism

- `permit(_owner, _spender, _value, _deadline, _v, _r, _s)` (`CurveStableSwapNG.vy` 1622-1668): if
  `_owner.is_contract`, it packs `(r, s, v)` into `Bytes[65]` and requires
  `ERC1271(_owner).isValidSignature(digest, sig) == 0x1626ba7e`; otherwise `ecrecover(digest, v, r, s) == _owner`.
  It then sets `allowance[_owner][_spender]`.
- The `ERC1271` interface is declared with `_signature: Bytes[65]` (line 68), and the external function takes
  `uint8, bytes32, bytes32`: a post-quantum signature (0.7–17 KB) cannot be passed.
- A migrated account with code is never sent to `ecrecover` here, so its old key cannot forge a permit (the part that
  made the draft PQ-13).

## Evidence

- CHECKED (Sourcify full match, Vyper 0.3.10, 2026-11-17): `permit`, the `ERC1271` interface and the admin functions
  (`ramp_A`, `stop_ramp_A`, `set_new_fee`, `set_ma_exp_time`, gated on `factory.admin()`)
  ([`review-notes.md`](../evidence/curve-stableswap-ng-permit/review-notes.md),
  [`source-excerpts.md`](../evidence/curve-stableswap-ng-permit/source-excerpts.md)).
- CHECKED (on-chain read at block 26,431,214): plain contract, no proxy; holds BUSD0 and USD0 worth $266k
  ([`onchain.json`](../evidence/curve-stableswap-ng-permit/onchain.json)).
- CHECKED (latest block, 2026-11-17): LP `totalSupply()` 267,503 at virtual price 1.011; factory admin
  `0xeda0108d…`.
- CHECKED (Xatu, any function): 202 transactions 2026-10-16 to 2026-11-16, last 2026-11-15
  ([`activity.json`](../evidence/curve-stableswap-ng-permit/activity.json)); 8 `ecrecover` transactions in the yearly
  window (`data/report/curated_contracts.csv`).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x1d08e7ad…` CurveStableSwapNG | no | $266k (pool reserves, not exposed) | 2026-11-15 | 202 |

Nothing can be taken through `permit` beyond what an address's own key already controls; the effect is that
post-quantum LP holders must use `approve()` instead. The $266k of pool reserves is not exposed by this check, so
`value_usd` is null. Other stableswap-ng pools share this `permit` code but were not part of this finding.

## Remediation

- Curve: a pool implementation whose `permit` takes `bytes signature` and forwards it unchanged to ERC-1271 (or uses
  ERC-7913). Existing pools cannot change; the factory admin `0xeda0108d…` can only add a new implementation for new
  pools.
- LP holders with post-quantum accounts: use `approve()` (an on-chain transaction) instead of `permit`.
- No protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated NONE (code checked first: no exposure beyond the account's own key).
- 2026-11-17 review (Review17): NONE -> LOW, step 4: the ERC-1271 path is limited to `Bytes[65]`, so this is PQ-3 (post-quantum accounts locked out of LP `permit`), not PQ-13; the feature is auxiliary and `approve()` remains, so nothing can be taken. Status not-affected -> confirmed; held value removed (pool reserves are not the exposure).
