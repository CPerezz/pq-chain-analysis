---
id: sav3token-6e10aacb-signed-shortcut-lost
title: "Sav3Token: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x6e10aacb89a28d6fa0fe68790777fec7e7f01890"
  family: "d45a74f33664ef764d6d527420fc22f8"
  name: "Sav3Token"
  label: "Sav3: SAV3 Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 54498
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 36
  last_active: 2026-11-17
fix:
  layer: none
  who_acts: "the affected holder (calls the direct function itself)"
evidence:
  level: source-read
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
  note: "Same act open by direct call: LOW."
---

## Summary

Sav3Token: Compound-style delegateBySig. A holder with code cannot delegate by signature but can call delegate(address) itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: delegateBySig (Compound style): whoever signed delegates; zero rejected. Read from source.
- delegate(address) 0x5c19a95c in runtime code at block 26438999
- delegate uses msg.sender as delegator (Compound COMP pattern)

## Impact and exposure

- Value held at block 26,438,999: $54,498 (ETH and 49 priced tokens).
- Activity: 36 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The holder calls delegate directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
