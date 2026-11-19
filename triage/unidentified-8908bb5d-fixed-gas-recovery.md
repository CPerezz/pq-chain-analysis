---
id: unidentified-8908bb5d-fixed-gas-recovery
title: "BullrunBabesOracle: under EIP-8151 every valid signature fails on activation day"
project: unidentified-8908bb5d
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x15e51c63518ab39281e80f9cd6d70930ad7ea8a5"
  name: "BullrunBabesOracle (study family da4c0033)"
  upgradeable: "unknown"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families da4c0033"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $180 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x15e51c63518ab39281e80f9cd6d70930ad7ea8a5` (BullrunBabesOracle, family `da4c0033`, 1 address, $180): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
