---
id: volatilityv4-b6cc399a-signed-shortcut-lost
title: "VolatilityV4: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb6cc399a0d3d3170a1c3316aba2c024e7fa0dc6c"
  family: "80deb501d13372adb8559d0b9f01de85"
  copies: 213
  name: "VolatilityV4"
  upgradeable: "no"
  rating: LOW
  txs_90d: 5127
  last_active: 2026-11-15
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

VolatilityV4: permit stops working for a holder whose address has code; the act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here. Read from source.
- bytecode exposes approve(address,uint256) 0x095ea7b3 and transfer 0xa9059cbb
- study note: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here. Read from source.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 213 addresses).
- Activity: 5,127 transactions called it in the 90 days before that block; last on 2026-11-15.

## Remediation

Holder calls approve itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
