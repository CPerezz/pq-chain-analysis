---
id: 88bdee37-7702-own-key-only
title: "0x88bdee37: 7702 logic that accepts only the account's own key"
status: confirmed
severity: LOW
patterns: [PQ-20]
impact: funds-locked
contracts:
- address: "0x88bdee37c71d3910bc7cde42b513de9234adbc51"
  family: "ffa92c9af7328c0c90c2ee3925fe059b"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "account holders keep the delegation or pick logic with another key"
evidence:
  level: bytecode
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

Contract `0x88bdee37c71d3910bc7cde42b513de9234adbc51`. EIP-7702 account logic that accepts only the account's own key; an account that takes it as real code is locked.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: the code accepts only the signature of the account it runs in. As 7702 delegate code it is not affected. An account that took this logic as real code could not sign for itself. Rule: self-only.
- Reviewed through the root issue's mechanism (D-025): the delegate's signature check requires the recovered address to be the account itself, so an account that later holds real code fails its own check; the account fixes it by re-delegating to logic that does not rely on its own key, or by keeping its EIP-7702 delegation, which EIP-8151 exempts (LOW)
- A random sample of 25 of the 668 rows below Anon's thresholds was checked one by one: all 25 hold at LOW
- The 100 rows over the thresholds (5 ETH or 1,000 transactions in 90 days) were checked one by one: 95 LOW, 5 not affected

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Delegates must not be offered as real-code migration targets; accounts keep the delegation or move to logic with another key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
