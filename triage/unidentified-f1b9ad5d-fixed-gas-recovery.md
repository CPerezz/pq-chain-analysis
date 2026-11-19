---
id: unidentified-f1b9ad5d-fixed-gas-recovery
title: "LiquidityTransformer: under EIP-8151 every valid signature fails on activation day"
project: unidentified-f1b9ad5d
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xc2a4705ecc9dab55dcc9432c7530731321490323"
  name: "LiquidityTransformer (study family 02767e1e)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 02767e1e"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xc2a4705ecc9dab55dcc9432c7530731321490323` (LiquidityTransformer, family `02767e1e`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
