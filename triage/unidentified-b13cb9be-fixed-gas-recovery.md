---
id: unidentified-b13cb9be-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-b13cb9be
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xd5fb59d9402c382746abf223511fba1aefd3a268"
  name: "UniLotteryRandomnessProvider (study family 49ef4c93)"
  upgradeable: "unknown"
- address: "0x87cbf8b62e4d268a103ce1f7b3a49694ca18375d"
  name: "UniLotteryRandomnessProvider (study family 85dbef00)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 49ef4c93, 85dbef00"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xd5fb59d9402c382746abf223511fba1aefd3a268` (UniLotteryRandomnessProvider, family `49ef4c93`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x87cbf8b62e4d268a103ce1f7b3a49694ca18375d` (UniLotteryRandomnessProvider, family `85dbef00`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
