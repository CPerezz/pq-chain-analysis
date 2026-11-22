---
id: ambire-d7974ab5-7702-own-key-only
title: "AmbireAccount7702: 7702 logic that accepts only the account's own key"
project: ambire
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xd7974ab51ea966aee19fb8b6ebab8c22074e16c0"
  family: "a8dadc5a689089c3da1b5dcf9f99e9f5"
  copies: 282
  name: "AmbireAccount7702"
  upgradeable: "no"
  rating: LOW
  value_usd: 1683474
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3481
  last_active: 2026-11-18
  recoveries_14d: 140
fix:
  layer: account-migration
  who_acts: "each account owner"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-7702-own-key-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "As the other Ambire row"
---

## Summary

AmbireAccount7702 (282 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: Ambire account (7702, variant) execute: as above / Ambire account ERC-1271: the recovered key must hold a privilege / Ambire account (7702, variant) validateUserOp: the recovered key must hold a…. Read from source.
- AmbireAccount7702 (variant): same privilege logic, address(this) has privilege 2 (line 17); other privileged keys can be added by the account/source (dossier a8dadc5a689089c3da1b5dcf9f99e9f5)
- Study note: Ambire account (7702, variant) execute: as above / Ambire account ERC-1271: the recovered key must hold a privilege / Ambire account (7702, variant) validateUserOp: the recovered key must hold a…. Read from source.
- Activity (measured): txs_90d 3,481, last_active 2026-11-18, value_usd 1683474

## Impact and exposure

- Value held at block 26,438,999: $1.7M (ETH and 49 priced tokens, over 282 addresses).
- Activity: 3,481 transactions called it in the 90 days before that block; last on 2026-11-18.
- 140 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
