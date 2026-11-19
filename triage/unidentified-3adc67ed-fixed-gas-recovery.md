---
id: unidentified-3adc67ed-fixed-gas-recovery
title: "Fog: under EIP-8151 every valid signature fails on activation day"
project: unidentified-3adc67ed
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x1e626d65205e15daace5fdb5b4c1eb914a25ac37"
  name: "Fog (study family 963713be)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 963713be"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x1e626d65205e15daace5fdb5b4c1eb914a25ac37` (Fog, family `963713be`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
