---
id: unidentified-6dad1d9d-fixed-gas-recovery
title: "MZT1: under EIP-8151 every valid signature fails on activation day"
project: unidentified-6dad1d9d
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x0bc146385d4a1b64bf214279d7b84784f1ade72b"
  name: "MZT1 (study family c1e5c95e)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c1e5c95e"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x0bc146385d4a1b64bf214279d7b84784f1ade72b` (MZT1, family `c1e5c95e`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
