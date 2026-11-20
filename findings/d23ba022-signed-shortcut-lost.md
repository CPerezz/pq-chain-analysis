---
id: d23ba022-signed-shortcut-lost
title: "0xd23ba022: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xd23ba02253d078584ff5d1f6e850e97a6ce3e684"
  family: "ba86aea9941f42357465c591ded8e9ad"
  copies: 4
  upgradeable: "yes"
  rating: LOW
  value_usd: 67851
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
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
  note: "Direct transfer and withdraw exist; read from names only: LOW."
---

## Summary

Unverified upgradeable token: transferWithPermit and signed withdrawals by the named holder. A holder with code keeps transfer and withdraw by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: token with permit-style transfers and withdrawals signed by the holder named. Bytecode and names.
- batch facts exits: transfer(address,uint256), transferFrom, withdraw(uint256), transferWithPermit(...)
- implementation 0xf82c97b0...: approve and transfer selectors in runtime code at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $67,851 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The holder calls transfer / withdraw directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
