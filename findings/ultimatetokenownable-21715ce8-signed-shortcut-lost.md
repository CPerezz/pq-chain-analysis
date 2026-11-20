---
id: ultimatetokenownable-21715ce8-signed-shortcut-lost
title: "UltimateTokenOwnable: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x21715ce80ce088794fc70a075acfa63bff20b0ea"
  family: "222af8985b12cea6a41a3430c7558bfb"
  copies: 859
  name: "UltimateTokenOwnable"
  label: "created by CreateMyToken: Deployer"
  upgradeable: "no"
  rating: LOW
  txs_90d: 6441
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
  note: "Standard signed shortcut; approve remain open to the same holder."
---

## Summary

UltimateTokenOwnable: permit stops working for a holder whose address has code; the act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Solady ERC20 permit (variant, assembly): the recovered address must be the owner named. Read from source.
- EIP-1167 clone of 0x1a505b75847a5728bd352c493587ab67f6dd8ec6; implementation bytecode has approve (0x095ea7b3), transfer, permit selectors
- study note: Solady ERC20 permit (variant, assembly): the recovered address must be the owner named. Read from source.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 859 addresses).
- Activity: 6,441 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Holder calls approve itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
