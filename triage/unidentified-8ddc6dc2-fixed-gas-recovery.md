---
id: unidentified-8ddc6dc2-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-8ddc6dc2
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x47414a04f29930c8e1c10f0b4791a9ddf3836efd"
  name: "EthLottery (study family 7ff04286)"
  upgradeable: "unknown"
- address: "0x1bb9e4b787e100d4827cf94866e30ea6e1d75709"
  name: "EthLottery (study family b56fa784)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 7ff04286, b56fa784"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x47414a04f29930c8e1c10f0b4791a9ddf3836efd` (EthLottery, family `7ff04286`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x1bb9e4b787e100d4827cf94866e30ea6e1d75709` (EthLottery, family `b56fa784`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
