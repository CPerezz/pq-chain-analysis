---
id: bdefitoken-041de28a-signed-shortcut-lost
title: "BDeFiToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x041de28a57ca96cb7ab3dde012b54729177266e4"
  family: "f248778e8f15fd5c92f13d1d6d9bfef2"
  copies: 69
  name: "BDeFiToken"
  upgradeable: "no"
  rating: LOW
  txs_90d: 7214
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

BDeFiToken: permit stops working for a holder whose address has code; the act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: as its template 3b28342b: permit: the owner named in the call must equal the recovered address; the holder can call approve itself. Template.
- EIP-1167 clone of 0x135916242715687ebba6f183369877024009c4c2; implementation bytecode has approve (0x095ea7b3), transfer, permit selectors
- study note: as its template 3b28342b: permit: the owner named in the call must equal the recovered address; the holder can call approve itself. Template.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 69 addresses).
- Activity: 7,214 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Holder calls approve itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
