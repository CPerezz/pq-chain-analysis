---
id: unidentified-853012bc-fixed-gas-recovery
title: "Mobius2Dv2: under EIP-8151 every valid signature fails on activation day"
project: unidentified-853012bc
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xb4a448387403554616eb5b50aa4c48f75243a015"
  name: "Mobius2Dv2 (study family b063805f)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b063805f"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xb4a448387403554616eb5b50aa4c48f75243a015` (Mobius2Dv2, family `b063805f`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
