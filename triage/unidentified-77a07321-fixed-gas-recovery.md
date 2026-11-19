---
id: unidentified-77a07321-fixed-gas-recovery
title: "Factory: under EIP-8151 every valid signature fails on activation day"
project: unidentified-77a07321
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x9accc0b9a45cd25d0c40559e60a8b6d410e07f1c"
  name: "Factory (study family a6fb2be6)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families a6fb2be6"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x9accc0b9a45cd25d0c40559e60a8b6d410e07f1c` (Factory, family `a6fb2be6`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
