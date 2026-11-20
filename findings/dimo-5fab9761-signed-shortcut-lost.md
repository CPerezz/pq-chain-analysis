---
id: dimo-5fab9761-signed-shortcut-lost
title: "Dimo: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x5fab9761d60419c9eeebe3915a8fa1ed7e8d2e1b"
  family: "4fa7f9818b831da04b64d33a586c3390"
  copies: 2
  name: "Dimo"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 6409
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
  note: "Standard signed shortcut; approve and delegate remain open to the same holder."
---

## Summary

Dimo: permit / delegateBySig stops working for a holder whose address has code; the act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use delegateBySig, permit; it can still call approve, delegate itself: a way of signing is lost, no right. Rule: permit-like.
- bytecode (proxy+implementation 0xc67872eb67cdab3d42270d100c491fd70ab1a448) exposes approve(address,uint256) 0x095ea7b3 and transfer 0xa9059cbb
- bytecode exposes delegate(address) 0x5c19a95c next to delegateBySig 0xc3cda520
- study note: a holder whose address has code can no longer use delegateBySig, permit; it can still call approve, delegate itself: a way of signing is lost, no right. Rule: permit-like.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 6,409 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Holder calls approve / delegate itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
