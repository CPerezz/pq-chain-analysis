---
id: basicsmartaccount-cdc56762-7702-own-key-only
title: "BasicSmartAccount: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: liveness
contracts:
- address: "0xcdc567626b01fc0f4c579829283e7869dea17ca3"
  family: "e965a1ccbf4182eac5d8957eb981af67"
  copies: 19637
  name: "BasicSmartAccount"
  upgradeable: "no"
  rating: LOW
  value_usd: 14398223
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 18730
  last_active: 2026-11-18
  recoveries_14d: 1558
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

BasicSmartAccount (19,637 accounts): 7702 delegate logic whose signature check needs the recovered address to equal address(this). Delegated accounts are unaffected; only an account that later holds real code fails its own check.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the recovered address must be the address the code runs at: the account's own key signs. Read from source. Executed: a real transaction reverts once the account holds this logic as real code.
- BasicSmartAccount: `address(this) == ecrecover(hash, v, r, s)` in _isValidSignature (lines 110-111)/source (dossier e965a1ccbf4182eac5d8957eb981af67)
- Study note: the recovered address must be the address the code runs at: the account's own key signs. Read from source. Executed: a real transaction reverts once the account holds this logic as real code.
- Activity (measured): txs_90d 18,730, last_active 2026-11-18, value_usd 14398223

## Impact and exposure

- Value held at block 26,438,999: $14.4M (ETH and 49 priced tokens, over 19,637 addresses).
- Activity: 18,730 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,558 signature recoveries in the study's two-week trace window.

## Remediation

Keep the 7702 delegation, or re-delegate to logic with a code-aware check, before or after the account gets real code; the account's own key acts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
