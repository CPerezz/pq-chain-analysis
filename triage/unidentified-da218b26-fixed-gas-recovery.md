---
id: unidentified-da218b26-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-da218b26
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xdaa91741742de94f352f4294e43e30799ee6e4d5"
  name: "unverified code (study family 2bef3cc3)"
  upgradeable: "unknown"
- address: "0xda21ac8e03c18b0da527f08ed04dbe86f5f95e63"
  name: "unverified code (study family 4301484d)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 2bef3cc3, 4301484d"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xdaa91741742de94f352f4294e43e30799ee6e4d5` (unverified, family `2bef3cc3`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xda21ac8e03c18b0da527f08ed04dbe86f5f95e63` (unverified, family `4301484d`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
