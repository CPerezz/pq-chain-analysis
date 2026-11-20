---
id: relayadapt7702-b395c947-7702-own-key-only
title: "RelayAdapt7702: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xb395c9475cd6c730bb51c72f4225c7a949293a59"
  family: "44b5541efc7a6716446e38d4db32b7ff"
  copies: 3537
  name: "RelayAdapt7702"
  upgradeable: "no"
  rating: LOW
  value_usd: 135883
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5607
  last_active: 2026-11-17
  recoveries_14d: 1332
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

RelayAdapt7702 (3,537 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the recovered address must be the address the code runs at: the account's own key signs. Read from source.
- Railgun RelayAdapt7702: `require(ECDSA.recover(hash,_signature) == address(this))` (lines 296, 355); onlySelf checks msg.sender == address(this)/source (dossier 44b5541efc7a6716446e38d4db32b7ff)
- Study note: the recovered address must be the address the code runs at: the account's own key signs. Read from source.
- Activity (measured): txs_90d 5,607, last_active 2026-11-17, value_usd 135883

## Impact and exposure

- Value held at block 26,438,999: $135,883 (ETH and 49 priced tokens, over 3,537 addresses).
- Activity: 5,607 transactions called it in the 90 days before that block; last on 2026-11-17.
- 1,332 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
