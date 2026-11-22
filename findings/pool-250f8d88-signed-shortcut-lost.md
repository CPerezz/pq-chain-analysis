---
id: pool-250f8d88-signed-shortcut-lost
title: "Pool: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x250f8d88173e0d9b692a9742f54e87e01a9fa54e"
  family: "bba59d773e89f450537e8aafb3a49e37"
  copies: 6
  name: "Pool"
  upgradeable: "no"
  rating: LOW
  value_usd: 198682
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5
  last_active: 2026-09-30
fix:
  layer: none
  who_acts: "the affected holder (calls the direct function itself)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Both signed acts have a direct call for the same owner: LOW."
---

## Summary

Yield v1 Pool (fyDai pool token): permit and addDelegateBySignature check the owner's signature. An owner with code can still call approve and addDelegate directly.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Yield v1 addDelegateBySignature: the user named must have signed / Yield v1 permit: the owner named must have signed. Read from source.
- approve 0x095ea7b3 and addDelegate(address) 0xe71bdf41 in runtime code at block 26438999
- Row note: addDelegateBySignature/permit need the named user's signature
- Both direct functions act for msg.sender

## Impact and exposure

- Value held at block 26,438,999: $198,682 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 5 transactions called it in the 90 days before that block; last on 2026-09-30.

## Remediation

The owner calls approve / addDelegate directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
