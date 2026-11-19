---
id: unidentified-b3d683e9-fixed-gas-recovery
title: "Dice (2 copies): under EIP-8151 every valid signature fails on activation day"
project: unidentified-b3d683e9
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x67df3e4661ab79ec8570aa7af86d5bc4de687490"
  name: "Dice (study family 80807afc), 1 of 2 addresses running it"
  upgradeable: "unknown"
families:
- code: "0x67df3e4661ab79ec8570aa7af86d5bc4de687490"
  name: "Dice (study family 80807afc)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 80807afc"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 2 addresses, $180 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x67df3e4661ab79ec8570aa7af86d5bc4de687490` (Dice, family `80807afc`, 2 addresses, $180): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
