---
id: unidentified-94876666-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-94876666
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xc82e3aa21a9e62b58a17f01c2c84ed11b7cf0df3"
  name: "unverified code (study family a73dea3b)"
  upgradeable: "unknown"
- address: "0xd82c60a1a74f7568cc24059f3c90bf0591cacb65"
  name: "unverified code (study family c701c51c)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families a73dea3b, c701c51c"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xc82e3aa21a9e62b58a17f01c2c84ed11b7cf0df3` (unverified, family `a73dea3b`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xd82c60a1a74f7568cc24059f3c90bf0591cacb65` (unverified, family `c701c51c`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
