---
id: unidentified-65892f21-fixed-gas-recovery
title: "2 contract families (5 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-65892f21
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x1987aa337387b62a88b1c4d9a3dfb2506d38ffef"
  name: "unverified code (study family 7d0cf8b4), 1 of 4 addresses running it"
  upgradeable: "unknown"
- address: "0x1e7fb727a5314c320b538276f23fbd7b0878ab1d"
  name: "unverified code (study family 97d7caca)"
  upgradeable: "unknown"
families:
- code: "0x1987aa337387b62a88b1c4d9a3dfb2506d38ffef"
  name: "unverified code (study family 7d0cf8b4)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 7d0cf8b4, 97d7caca"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 5 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x1987aa337387b62a88b1c4d9a3dfb2506d38ffef` (unverified, family `7d0cf8b4`, 4 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x1e7fb727a5314c320b538276f23fbd7b0878ab1d` (unverified, family `97d7caca`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
