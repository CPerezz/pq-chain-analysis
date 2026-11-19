---
id: unidentified-f1475eab-fixed-gas-recovery
title: "3 unverified contracts with one code: under EIP-8151 every valid signature fails on activation day"
project: unidentified-f1475eab
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x5b4a7801badcfe985ac3b5a18d38d6f88e2269ad"
  name: "unverified code (study family a6a47827), 1 of 3 addresses running it"
  upgradeable: "unknown"
families:
- code: "0x5b4a7801badcfe985ac3b5a18d38d6f88e2269ad"
  name: "unverified code (study family a6a47827)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families a6a47827"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 3 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x5b4a7801badcfe985ac3b5a18d38d6f88e2269ad` (unverified, family `a6a47827`, 3 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
