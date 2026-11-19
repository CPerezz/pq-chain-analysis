---
id: unidentified-3dcbcfee-fixed-gas-recovery
title: "3 contract families (4 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-3dcbcfee
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x199daaadd0033078e57c6e266d7e3528ec6bc390"
  name: "unverified code (study family 70d3033a)"
  upgradeable: "unknown"
- address: "0x19194739775f65e410e07d55266f099c508ba0cd"
  name: "unverified code (study family 38524b81), 1 of 2 addresses running it"
  upgradeable: "unknown"
- address: "0x14d05044a79eb54d6579b2099759e7248f694d8c"
  name: "unverified code (study family 42eab461)"
  upgradeable: "unknown"
families:
- code: "0x19194739775f65e410e07d55266f099c508ba0cd"
  name: "unverified code (study family 38524b81)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 70d3033a, 38524b81, 42eab461"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 3 code families, 4 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x199daaadd0033078e57c6e266d7e3528ec6bc390` (unverified, family `70d3033a`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x19194739775f65e410e07d55266f099c508ba0cd` (unverified, family `38524b81`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x14d05044a79eb54d6579b2099759e7248f694d8c` (unverified, family `42eab461`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
