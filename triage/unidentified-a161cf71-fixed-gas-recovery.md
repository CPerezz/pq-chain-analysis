---
id: unidentified-a161cf71-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-a161cf71
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x44b173cbdfc9946963d871c3f8b680d6a7085e2c"
  name: "lottery (study family 94786d1c)"
  upgradeable: "unknown"
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x336f319875cac0677602ae46202e91f00fdf27c4"
  name: "unverified code (study family 65e24af5)"
  upgradeable: "unknown"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 94786d1c, 65e24af5"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $1k held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x44b173cbdfc9946963d871c3f8b680d6a7085e2c` (lottery, family `94786d1c`, 1 address, $902): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x336f319875cac0677602ae46202e91f00fdf27c4` (unverified, family `65e24af5`, 1 address, $180): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
