---
id: wrappedmtoken-437cc333-signed-shortcut-lost
title: "WrappedMToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x437cc33344a0b27a429f795ff6b469c72698b291"
  family: "544acfe177a2cc7468f6e1ea1d01778c"
  copies: 2
  name: "WrappedMToken"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 8027
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

WrappedMToken: permit stops working for a holder whose address has code; the act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use cancelAuthorization, permit, permit(bytes), receiveWithAuthorization, transferWithAuthorization; it can still call approve, transfer itself: a way of…. Rule: permit-like.
- bytecode (proxy+implementation 0x6d9db63afccf515f393d5e65be69d38bb3b29d13) exposes approve(address,uint256) 0x095ea7b3 and transfer 0xa9059cbb
- study note: a holder whose address has code can no longer use cancelAuthorization, permit, permit(bytes), receiveWithAuthorization, transferWithAuthorization; it can still call approve, transf

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 8,027 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Holder calls approve itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
