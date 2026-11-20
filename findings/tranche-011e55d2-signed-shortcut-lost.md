---
id: tranche-011e55d2-signed-shortcut-lost
title: "Tranche: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x011e55d2b28306458e37ca7e997c879bb25a455d"
  family: "d962842e4938e64e3903741e26399601"
  copies: 10
  name: "Tranche"
  label: "Strata: jrUSDat Token"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 3948
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

Tranche: permit stops working for a holder whose address has code; the act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use permit; it can still call approve itself: a way of signing is lost, no right. Rule: permit-like.
- bytecode (proxy+implementation 0x5c8df1867dae4db77903d4aec24a09e81e72a6db) exposes approve(address,uint256) 0x095ea7b3 and transfer 0xa9059cbb
- study note: a holder whose address has code can no longer use permit; it can still call approve itself: a way of signing is lost, no right. Rule: permit-like.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 10 addresses).
- Activity: 3,948 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Holder calls approve itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
