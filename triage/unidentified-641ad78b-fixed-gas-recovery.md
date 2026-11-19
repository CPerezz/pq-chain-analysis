---
id: unidentified-641ad78b-fixed-gas-recovery
title: "3 contract families (3 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-641ad78b
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xfef0d2f3a79b4338d8418003dd9df89281242063"
  name: "LiquidityTransformer (study family 282894bb)"
  upgradeable: "unknown"
  value_usd: 1263
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x6b0f51c63b1b7d0c2246fe24a653f2c0eb74dd60"
  name: "unverified code (study family 8255a805)"
  upgradeable: "unknown"
- address: "0x2dedcda70c6724a5833a8e07c0103c0e5face529"
  name: "unverified code (study family b5824a0b)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 282894bb, 8255a805, b5824a0b"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 3 code families, 3 addresses, $1k held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xfef0d2f3a79b4338d8418003dd9df89281242063` (LiquidityTransformer, family `282894bb`, 1 address, $1k): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x6b0f51c63b1b7d0c2246fe24a653f2c0eb74dd60` (unverified, family `8255a805`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x2dedcda70c6724a5833a8e07c0103c0e5face529` (unverified, family `b5824a0b`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
