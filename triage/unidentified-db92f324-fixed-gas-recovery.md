---
id: unidentified-db92f324-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-db92f324
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xb01fa542a9f60381df625454480b60f03442b2f4"
  name: "unverified code (study family 802fa95d)"
  upgradeable: "unknown"
- address: "0x199b0999e2ead19d0f0e9d459071351de77a210d"
  name: "unverified code (study family ba7f1f3a)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 802fa95d, ba7f1f3a"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xb01fa542a9f60381df625454480b60f03442b2f4` (unverified, family `802fa95d`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x199b0999e2ead19d0f0e9d459071351de77a210d` (unverified, family `ba7f1f3a`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
