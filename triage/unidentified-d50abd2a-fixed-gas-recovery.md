---
id: unidentified-d50abd2a-fixed-gas-recovery
title: "Unverified contract 0x4c1f06…: under EIP-8151 every valid signature fails on activation day"
project: unidentified-d50abd2a
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x4c1f06cdc59dd46f6d763d995e938605c0d9e8f0"
  name: "unverified code (study family 2b1798f5)"
  upgradeable: "unknown"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 2b1798f5"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $541 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x4c1f06cdc59dd46f6d763d995e938605c0d9e8f0` (unverified, family `2b1798f5`, 1 address, $541): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
