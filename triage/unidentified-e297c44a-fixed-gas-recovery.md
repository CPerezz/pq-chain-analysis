---
id: unidentified-e297c44a-fixed-gas-recovery
title: "Roll100: under EIP-8151 every valid signature fails on activation day"
project: unidentified-e297c44a
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xb117e420c331cdca76121a7c2d521d9c44931e10"
  name: "Roll100 (study family 74edad41)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 74edad41"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xb117e420c331cdca76121a7c2d521d9c44931e10` (Roll100, family `74edad41`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
