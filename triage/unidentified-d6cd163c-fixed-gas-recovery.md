---
id: unidentified-d6cd163c-fixed-gas-recovery
title: "RNGOracle: under EIP-8151 every valid signature fails on activation day"
project: unidentified-d6cd163c
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x5a4e4b5e2e78bf2d9df2cd916106862e5873f819"
  name: "RNGOracle (study family bc6236c1)"
  upgradeable: "unknown"
  value_usd: 1444
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families bc6236c1"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $1k held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x5a4e4b5e2e78bf2d9df2cd916106862e5873f819` (RNGOracle, family `bc6236c1`, 1 address, $1k): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
