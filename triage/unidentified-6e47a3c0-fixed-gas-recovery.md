---
id: unidentified-6e47a3c0-fixed-gas-recovery
title: "3 contract families (3 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-6e47a3c0
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x136b9e17e56ba927884e92661a850f2d1a621ee6"
  name: "BalloonsX9 (study family 097c0fc1)"
  upgradeable: "unknown"
- address: "0xa2e39fb7a25d04fad42c3083dc5009e97ed01988"
  name: "Balloons3D (study family d0f1f6c9)"
  upgradeable: "unknown"
- address: "0xeea29b5b5ae2e0e611d980152f9fbc893bc7c179"
  name: "unverified code (study family 5bbae606)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 097c0fc1, d0f1f6c9, 5bbae606"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 3 code families, 3 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x136b9e17e56ba927884e92661a850f2d1a621ee6` (BalloonsX9, family `097c0fc1`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xa2e39fb7a25d04fad42c3083dc5009e97ed01988` (Balloons3D, family `d0f1f6c9`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xeea29b5b5ae2e0e611d980152f9fbc893bc7c179` (unverified, family `5bbae606`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
