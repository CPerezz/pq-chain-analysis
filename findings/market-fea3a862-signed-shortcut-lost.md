---
id: market-fea3a862-signed-shortcut-lost
title: "Market: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xfea3a862ee4b3f9b6015581d6d2d25af816c54f1"
  family: "ef3e77071ba0e20d9d17584d7bd1f435"
  copies: 5
  name: "Market"
  upgradeable: "no"
  rating: LOW
  txs_90d: 9905
  last_active: 2026-11-18
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
  note: "Direct borrow/withdraw remain open to the same user."
---

## Summary

Inverse FiRM Market: borrowOnBehalf/withdrawOnBehalf need an ECDSA signature from `from`, which fails when that address has code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Inverse FiRM borrowOnBehalf: the account named `from` must have signed for this caller / Inverse FiRM withdrawOnBehalf: the account named `from` must have signed for this caller / Inverse FiRM…. Read (function text).
- source/src/Market.sol:416 borrow(uint) and withdraw(uint) callable by the user directly
- Market.sol:430 borrowOnBehalf(from,...) is the signed variant

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 9,905 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

User calls borrow/withdraw itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
