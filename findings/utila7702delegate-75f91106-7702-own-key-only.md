---
id: utila7702delegate-75f91106-7702-own-key-only
title: "Utila7702Delegate: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0x75f91106e62ac24df2987d033eb8471bd4ed8439"
  family: "d9044f6a847131108d14cf3b90539e81"
  copies: 7332
  name: "Utila7702Delegate"
  upgradeable: "no"
  rating: LOW
  value_usd: 8465011
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 19489
  last_active: 2026-11-18
  recoveries_14d: 6
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
  note: "Pure own-key check; re-delegation fixes it -> LOW."
---

## Summary

Utila7702Delegate (7,332 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the recovered address must be the address the code runs at: the account's own key signs. Read from source.
- Utila7702Delegate (variant): tryRecover == address(this) (lines 163-167); signed batch recover == address(this) (line 536)/source (dossier d9044f6a847131108d14cf3b90539e81)
- Study note: the recovered address must be the address the code runs at: the account's own key signs. Read from source.
- Activity (measured): txs_90d 19,489, last_active 2026-11-18, value_usd 8465011

## Impact and exposure

- Value held at block 26,438,999: $8.5M (ETH and 49 priced tokens, over 7,332 addresses).
- Activity: 19,489 transactions called it in the 90 days before that block; last on 2026-11-18.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
