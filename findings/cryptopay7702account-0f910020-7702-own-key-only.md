---
id: cryptopay7702account-0f910020-7702-own-key-only
title: "CryptoPay7702Account: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: funds-locked
contracts:
- address: "0x0f91002050055beb999df9ed3a1bb201767410f7"
  family: "9e1c415fb1eb126377a1590e705a3c8f"
  copies: 29
  name: "CryptoPay7702Account"
  upgradeable: "no"
  rating: LOW
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 71
  last_active: 2026-11-15
  recoveries_14d: 36
fix:
  layer: account-migration
  who_acts: "account holders keep the delegation or pick logic with another key"
evidence:
  level: executed
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
  note: "reviewed through the root issue's mechanism and a random sample (D-025)"
---

## Summary

`CryptoPay7702Account` at `0x0f91002050055beb999df9ed3a1bb201767410f7`, with 28 more addresses running its code. EIP-7702 account logic that accepts only the account's own key; an account that takes it as real code is locked.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the recovered address must be the address the code runs at: the account's own key signs. Read from source. Executed: a real transaction reverts once the account holds this logic as real code.
- Reviewed through the root issue's mechanism (D-025): the delegate's signature check requires the recovered address to be the account itself, so an account that later holds real code fails its own check; the account fixes it by re-delegating to logic that does not rely on its own key, or by keeping its EIP-7702 delegation, which EIP-8151 exempts (LOW)
- A random sample of 25 of the 668 rows below Anon's thresholds was checked one by one: all 25 hold at LOW
- The 100 rows over the thresholds (5 ETH or 1,000 transactions in 90 days) were checked one by one: 95 LOW, 5 not affected

## Impact and exposure

- Value held at block 26,438,999: $361 (ETH and 49 priced tokens, over 29 addresses).
- Activity: 71 transactions called it in the 90 days before that block; last on 2026-11-15.
- 36 signature recoveries in the study's two-week trace window.

## Remediation

Delegates must not be offered as real-code migration targets; accounts keep the delegation or move to logic with another key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
