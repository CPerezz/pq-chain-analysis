---
id: unidentified-907f0819-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-907f0819
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x1a460bde3f373f64c101c72857ba77994241843e"
  name: "unverified code (study family c124a7a8)"
  upgradeable: "unknown"
- address: "0x979b2dd26bcf1b391ff5afa7b0c818209889a832"
  name: "unverified code (study family acd4a177)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c124a7a8, acd4a177"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x1a460bde3f373f64c101c72857ba77994241843e` (unverified, family `c124a7a8`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x979b2dd26bcf1b391ff5afa7b0c818209889a832` (unverified, family `acd4a177`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
