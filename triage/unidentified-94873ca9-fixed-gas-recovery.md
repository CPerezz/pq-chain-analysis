---
id: unidentified-94873ca9-fixed-gas-recovery
title: "3 contract families (3 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-94873ca9
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x1cea89693fe39cbe245a0060f82ebdf525e9ea66"
  name: "unverified code (study family e30a58aa)"
  upgradeable: "unknown"
- address: "0xa8a22f42274bdd66b65abc8510fd808176f80cca"
  name: "unverified code (study family 925f75d5)"
  upgradeable: "unknown"
- address: "0xd069ea675280ab0f541303e8ab4b4ecafc61d0cb"
  name: "unverified code (study family 138b45a7)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families e30a58aa, 925f75d5, 138b45a7"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 3 code families, 3 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x1cea89693fe39cbe245a0060f82ebdf525e9ea66` (unverified, family `e30a58aa`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xa8a22f42274bdd66b65abc8510fd808176f80cca` (unverified, family `925f75d5`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xd069ea675280ab0f541303e8ab4b4ecafc61d0cb` (unverified, family `138b45a7`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
