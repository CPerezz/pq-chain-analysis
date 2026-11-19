---
id: unidentified-24880939-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-24880939
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x8aefd151b1f898d9971fea71bfe150e8e721b97d"
  name: "unverified code (study family b1534968)"
  upgradeable: "unknown"
- address: "0xb926e7c92dbd8daccb8f2ccaaaf721a00f9aaf4d"
  name: "unverified code (study family 2b184f64)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b1534968, 2b184f64"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x8aefd151b1f898d9971fea71bfe150e8e721b97d` (unverified, family `b1534968`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xb926e7c92dbd8daccb8f2ccaaaf721a00f9aaf4d` (unverified, family `2b184f64`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
