---
id: synterc20-70b7f704-signed-shortcut-lost
title: "SyntERC20: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x70b7f7044d2ca8e2f1e999b90ef16d7cb7a0cda1"
  family: "04dee77323cdd15914ff0f44cca3324b"
  copies: 5
  name: "SyntERC20"
  upgradeable: "no"
  rating: LOW
  txs_90d: 6969
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "the affected holder (calls the direct function itself)"
evidence:
  level: bytecode
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
  note: "Standard signed shortcut; approve remain open to the same holder."
---

## Summary

SyntERC20: permit stops working for a holder whose address has code; the act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use permit; it can still call approve itself: a way of signing is lost, no right. Rule: permit-like.
- bytecode exposes approve(address,uint256) 0x095ea7b3 and transfer 0xa9059cbb
- study note: a holder whose address has code can no longer use permit; it can still call approve itself: a way of signing is lost, no right. Rule: permit-like.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 6,969 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Holder calls approve itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
