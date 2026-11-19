---
id: unidentified-57874469-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-57874469
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x8f5ee036492342f8f83fdcf9093745c01a1603f2"
  name: "ShittyDice (study family 72517dee)"
  upgradeable: "unknown"
- address: "0x035afa4df29cdae9b0829aea574d3f2e07c09129"
  name: "ERCDICE (study family 6aa3128a)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 72517dee, 6aa3128a"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x8f5ee036492342f8f83fdcf9093745c01a1603f2` (ShittyDice, family `72517dee`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x035afa4df29cdae9b0829aea574d3f2e07c09129` (ERCDICE, family `6aa3128a`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
