---
id: unidentified-6ccab97e-fixed-gas-recovery
title: "1,168 unverified contracts with one code: under EIP-8151 every valid signature fails on activation day"
project: unidentified-6ccab97e
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x5ee190e83ed4f83182da958c10582d60849486af"
  name: "unverified code (study family cb74eed3), 1 of 1,168 addresses running it"
  upgradeable: "no"
families:
- code: "0x5ee190e83ed4f83182da958c10582d60849486af"
  name: "unverified code (study family cb74eed3)"
  instances: 1168
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families cb74eed3"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1,168 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x5ee190e83ed4f83182da958c10582d60849486af` (unverified, family `cb74eed3`, 1,168 addresses, $0): 1,168 wallets of the 3,072-gas pattern: owners added and removed by functions. Decided by: bytecode and names (no source).
