---
id: bonetoken-9813037e-signed-shortcut-lost
title: "BoneToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x9813037ee2218799597d83d4a5b6f3b6778218d9"
  family: "989a2cc59ab98a24902c127de097230c"
  name: "BoneToken"
  label: "ShibaSwap: BONE Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 71641
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 20630
  last_active: 2026-11-18
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

BoneToken (ShibaSwap): Compound-style delegateBySig. A holder with code cannot delegate by signature but can call delegate(address) itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: delegateBySig (Compound style): whoever signed delegates; zero rejected. Read from source.
- delegate(address) 0x5c19a95c in runtime code at block 26438999
- delegate uses msg.sender as delegator (Compound COMP pattern)

## Impact and exposure

- Value held at block 26,438,999: $71,641 (ETH and 49 priced tokens).
- Activity: 20,630 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The holder calls delegate directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
