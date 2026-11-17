---
id: 1inch-lop-order-sig-scheme-select
title: "1inch AggregationRouterV6: a quantum attacker who recovers a maker's old ECDSA key can fill limit orders against that maker's token approvals even after the address migrates to post-quantum validation"
project: 1inch
status: confirmed
severity: HIGH
patterns: [PQ-2]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x111111125421ca6dc452d289314280a0f8842a65"
  implementation: null
  name: AggregationRouterV6
  upgradeable: "no"
  admin: "owner Safe 0x9f8102b1bb05785bad2874f2c7b1aaea4c6d976a (3 of 4) can only pause, unpause and rescue tokens held by the router; no upgrade path (read at block 26431457)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 319187
families: []
fix:
  layer: account-migration
  who_acts: "each maker: revoke approvals to 0x111111125421ca6dc452d289314280a0f8842a65 or move funds to a fresh post-quantum address; 1inch can only deploy a new router (owner Safe 0x9f8102b1bb05785bad2874f2c7b1aaea4c6d976a cannot change this one)"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/1inch-lop-order-sig-scheme-select
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review09 (finding review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/1inch-lop-order-sig-scheme-select/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: HIGH
related: [1inch-v6-executor-signer]
---

## Summary

The limit-order part of 1inch's AggregationRouterV6 has two fill paths, and the taker picks one: `fillOrder` checks
the maker's ECDSA signature with `ecrecover` and never asks whether the maker has account code, while
`fillContractOrder` checks ERC-1271 with the full signature (PQ-2). Post-quantum smart accounts can make orders through
the ERC-1271 path, but an address that migrates in place (EIP-7702 or similar) keeps its old key valid on the ECDSA
path, so a quantum attacker who recovers that key can sign orders and fill them against whatever the maker has
approved to the router. The exposure is makers' approvals to the router, which is not measurable here. Rated HIGH
(step 4): users' own funds stay forgeable after migration in a contract that cannot change.

## Mechanism

- `fillOrder` / `fillOrderArgs` (verified source l.3769-3782) -> `_fillOrder`: on the first fill,
  `if (maker == address(0) || maker != ECDSA.recover(orderHash, r, vs)) revert BadSignature();` (l.3814). No code check,
  so the ECDSA key of an address is accepted even when the address has account code.
- `fillContractOrder` / `fillContractOrderArgs` (l.3834-3846) -> `_fillContractOrder`:
  `ECDSA.isValidSignature(order.maker.get(), orderHash, signature)` (l.3875), a staticcall to ERC-1271
  `isValidSignature(hash, bytes)` that copies the full calldata signature (l.1097-1117). Post-quantum accounts use this.
- What is released: `_fill` pulls the making asset from the maker (via the maker's ERC-20 approval to the router or an
  attached permit) and pays the taker.
- The router has no proxy; the owner can only `rescueFunds` (l.5765), `pause` and `unpause` (l.5772-5779).

Pattern PQ-2. Excerpts: [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/1inch-lop-order-sig-scheme-select/source-excerpts.md).

## Evidence

- CHECKED (Sourcify verified source, read 2026-11-17): both fill paths and the owner functions above
  ([`review-reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/1inch-lop-order-sig-scheme-select/review-reads.json)).
- CHECKED (on-chain at block 26,431,457): no proxy (24,294 bytes of code); `owner()` = Safe `0x9f8102b1…`, threshold 3
  of 4; `paused()` = false.
- CHECKED (precompile trace to March 2026): `ecrecover`; 1,240,719 pre-quantum calls in the year, in transactions
  moving $206.8B (`studies/top-callers-classification/results/curated_contracts.csv`, `txs_y1`, `usd_tx_y1`; the same money counted per transaction).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): 319,187 transactions called the router (any function)
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/1inch-lop-order-sig-scheme-select/activity.json)).
- INFERRED: the share of fills that use `fillOrder` versus `fillContractOrder` was not measured.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x11111112…` AggregationRouterV6 | no | — | 2026-11-16 | 319,187 |

The router holds nothing of value itself (dust; its holdings are not the exposure). What a forged maker signature
releases is the maker's balance approved to `0x111111125421ca6dc452d289314280a0f8842a65`; the sum of live approvals
across all makers was not measured, so the value step lowers nothing. Only addresses whose old ECDSA key still exists
are affected: a fresh post-quantum smart account has no ECDSA key and cannot be forged through `fillOrder`.

## Remediation

- Makers who migrate: revoke ERC-20 approvals (and Permit2 allowances) granted to the router from any address whose
  ECDSA key still exists, or move funds to a fresh post-quantum account and sign orders with ERC-1271.
- 1inch: this router cannot be changed. A new router whose ECDSA path checks `maker.code.length == 0` first (PQ-13) and
  whose ERC-1271 path takes full-length signatures would close it for new orders; users must move approvals to it.
- Protocol: EIP-8151 (make `ecrecover` fail for addresses with real code) would protect migrated addresses here without
  1inch or the users acting.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review09): HIGH kept (step 4). Both fill paths read in verified source (taker chooses the scheme; ERC-1271 path takes the full signature); owner Safe 3 of 4 re-read at block 26,431,457 and its powers limited to pause/unpause/rescueFunds.
