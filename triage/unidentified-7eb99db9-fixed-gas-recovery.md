---
id: unidentified-7eb99db9-fixed-gas-recovery
title: "2 unverified contracts with one code: under EIP-8151 every valid signature fails on activation day"
project: unidentified-7eb99db9
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xf8eb4c6a19215234fe82cb375f60947a3be24c06"
  name: "unverified code (study family 78f599ad), 1 of 2 addresses running it"
  upgradeable: "unknown"
families:
- code: "0xf8eb4c6a19215234fe82cb375f60947a3be24c06"
  name: "unverified code (study family 78f599ad)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 78f599ad"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xf8eb4c6a19215234fe82cb375f60947a3be24c06` (unverified, family `78f599ad`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
