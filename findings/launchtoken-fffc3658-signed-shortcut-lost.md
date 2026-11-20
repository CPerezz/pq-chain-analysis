---
id: launchtoken-fffc3658-signed-shortcut-lost
title: "LaunchToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xfffc365826ad1a207e33eecd0d12f34998f75222"
  family: "36d4d8314b38ea4b8af32d79fb74f33e"
  copies: 18
  name: "LaunchToken"
  upgradeable: "no"
  rating: LOW
  txs_90d: 6022
  last_active: 2026-11-14
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

LaunchToken: permit stops working for a holder whose address has code; the act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: as its template 8f1fc8e5: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here. Template.
- bytecode exposes approve(address,uint256) 0x095ea7b3 and transfer 0xa9059cbb
- study note: as its template 8f1fc8e5: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here. Template.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 18 addresses).
- Activity: 6,022 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

Holder calls approve itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
