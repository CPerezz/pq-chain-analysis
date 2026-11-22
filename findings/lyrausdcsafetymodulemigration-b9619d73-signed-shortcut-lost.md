---
id: lyrausdcsafetymodulemigration-b9619d73-signed-shortcut-lost
title: "LyraUsdcSafetyModuleMigration: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb9619d73c08076bc5d4f0470593e98b9eb19a219"
  family: "d0c6e5928a926285a0ceec53851bdb83"
  copies: 7
  name: "LyraUsdcSafetyModuleMigration"
  label: "Lyra Finance: stkLYRA Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 88965
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 9
  last_active: 2026-10-27
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
  note: "Every signed act has a direct call: LOW."
---

## Summary

Lyra stkLYRA (Aave-style staked token, upgradeable): permit, delegateBySig and delegateByTypeBySig. An owner with code keeps approve, delegate and delegateByType.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Aave v2 aToken permit: the owner named must have signed / delegateByTypeBySig: whoever signed is the delegator; a holder can call delegateByType itself / delegateBySig: whoever signed is the…. Read from source.
- implementation 0xc6ece726...: approve 0x095ea7b3, delegate 0x5c19a95c and delegateByType 0xdc937e1c in runtime code at block 26438999
- Row note: a holder can call delegateByType itself

## Impact and exposure

- Value held at block 26,438,999: $88,965 (ETH and 49 priced tokens, over 7 addresses).
- Activity: 9 transactions called it in the 90 days before that block; last on 2026-10-27.

## Remediation

The holder calls approve or delegate directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
