---
id: unidentified-834f4555-fixed-gas-recovery
title: "6 unverified contracts with one code: under EIP-8151 every valid signature fails on activation day"
project: unidentified-834f4555
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x35f5554c3823ea9b03d74f095cb02bd0314f5790"
  name: "unverified code (study family b7b87df5), 1 of 6 addresses running it"
  upgradeable: "unknown"
families:
- code: "0x35f5554c3823ea9b03d74f095cb02bd0314f5790"
  name: "unverified code (study family b7b87df5)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b7b87df5"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 6 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x35f5554c3823ea9b03d74f095cb02bd0314f5790` (unverified, family `b7b87df5`, 6 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
