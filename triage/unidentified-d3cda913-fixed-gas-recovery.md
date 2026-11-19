---
id: unidentified-d3cda913-fixed-gas-recovery
title: "2 contract families (5 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-d3cda913
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x1dd4ab0fb33f0401a2a3830363079eba9e4aa8cb"
  name: "unverified code (study family bf52cbad), 1 of 3 addresses running it"
  upgradeable: "unknown"
- address: "0x9e475f8b49be49daf0571a53dda0fc9bfdbcf505"
  name: "ECVerifyLib (study family c045c1e1), 1 of 2 addresses running it"
  upgradeable: "unknown"
families:
- code: "0x1dd4ab0fb33f0401a2a3830363079eba9e4aa8cb"
  name: "unverified code (study family bf52cbad)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
- code: "0x9e475f8b49be49daf0571a53dda0fc9bfdbcf505"
  name: "ECVerifyLib (study family c045c1e1)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families bf52cbad, c045c1e1"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 5 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x1dd4ab0fb33f0401a2a3830363079eba9e4aa8cb` (unverified, family `bf52cbad`, 3 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x9e475f8b49be49daf0571a53dda0fc9bfdbcf505` (ECVerifyLib, family `c045c1e1`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
