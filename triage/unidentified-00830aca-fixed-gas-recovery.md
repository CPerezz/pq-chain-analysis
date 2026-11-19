---
id: unidentified-00830aca-fixed-gas-recovery
title: "Roulette (7 copies): under EIP-8151 every valid signature fails on activation day"
project: unidentified-00830aca
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x26da32f65bf26a2acfd681c19a060b8ac6e5871d"
  name: "Roulette (study family d1c2d69c), 1 of 7 addresses running it"
  upgradeable: "unknown"
families:
- code: "0x26da32f65bf26a2acfd681c19a060b8ac6e5871d"
  name: "Roulette (study family d1c2d69c)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families d1c2d69c"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 7 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x26da32f65bf26a2acfd681c19a060b8ac6e5871d` (Roulette, family `d1c2d69c`, 7 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
