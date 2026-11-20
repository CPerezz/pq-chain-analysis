---
id: inv-41d5d794-signed-shortcut-lost
title: "INV: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x41d5d79431a913c4ae7d69a668ecdfe5ff9dfb68"
  family: "9e9cf39d0f92603e9a785964f7b79d18"
  name: "INV"
  upgradeable: "no"
  rating: LOW
  txs_90d: 7410
  last_active: 2026-11-17
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
  note: "Standard signed shortcut; approve and delegate remain open to the same holder."
---

## Summary

INV: permit / delegateBySig stops working for a holder whose address has code; the act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: as its template ee89f472: VSP delegateBySig: whoever signed delegates / VSP permit: the owner named must have signed. Template.
- bytecode exposes approve(address,uint256) 0x095ea7b3 and transfer 0xa9059cbb
- bytecode exposes delegate(address) 0x5c19a95c next to delegateBySig 0xc3cda520
- study note: as its template ee89f472: VSP delegateBySig: whoever signed delegates / VSP permit: the owner named must have signed. Template.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 7,410 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Holder calls approve / delegate itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
