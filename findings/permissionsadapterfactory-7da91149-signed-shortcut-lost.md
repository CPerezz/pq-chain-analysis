---
id: permissionsadapterfactory-7da91149-signed-shortcut-lost
title: "PermissionsAdapterFactory: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x7da911490ca4663e572ea9c8154f3cdebce16452"
  family: "cf57c426dd831e950eca104e5b5e52c2"
  name: "PermissionsAdapterFactory"
  upgradeable: "no"
  rating: LOW
  txs_90d: 5304
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

PermissionsAdapterFactory: permit stops working for a holder whose address has code; the act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here. Read (function text).
- bytecode exposes approve(address,uint256) 0x095ea7b3 and transfer 0xa9059cbb
- study note: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here. Read (function text).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 5,304 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Holder calls approve itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
