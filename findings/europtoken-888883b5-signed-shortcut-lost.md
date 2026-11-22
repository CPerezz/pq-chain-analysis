---
id: europtoken-888883b5-signed-shortcut-lost
title: "EUROPToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x888883b5f5d21fb10dfeb70e8f9722b9fb0e5e51"
  family: "06883a55654be2be3735e5f4fe9eeee9"
  copies: 2
  name: "EUROPToken"
  label: "EURØP: EUROP Token"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 6079
  last_active: 2026-11-18
  recoveries_14d: 2
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

EUROPToken: permit stops working for a holder whose address has code; the act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit: the owner named in the call must equal the recovered address; the holder can call approve itself / a transfer authorisation: the holder named must equal the recovered address; the holder can…. Read from source. Executed: a real transaction reverts with code at the signer.
- bytecode (proxy+implementation 0xfbdaf9745da69f927bc14bd73860ffdba82cff43) exposes approve(address,uint256) 0x095ea7b3 and transfer 0xa9059cbb
- study note: permit: the owner named in the call must equal the recovered address; the holder can call approve itself / a transfer authorisation: the holder named must equal the recovered addre

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 6,079 transactions called it in the 90 days before that block; last on 2026-11-18.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

Holder calls approve itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
