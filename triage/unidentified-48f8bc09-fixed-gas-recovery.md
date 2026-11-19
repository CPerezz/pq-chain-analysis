---
id: unidentified-48f8bc09-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-48f8bc09
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x43f816682850b1e7ac8b075aa1bd2ba309acf5c9"
  name: "LiquidityTransformer (study family 0a5d2425)"
  upgradeable: "unknown"
- address: "0x87aba878a41603a783b7701c38c87971bc43c6bf"
  name: "ProvableTest (study family 8f00b6a8)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 0a5d2425, 8f00b6a8"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x43f816682850b1e7ac8b075aa1bd2ba309acf5c9` (LiquidityTransformer, family `0a5d2425`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x87aba878a41603a783b7701c38c87971bc43c6bf` (ProvableTest, family `8f00b6a8`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
