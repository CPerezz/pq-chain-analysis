---
id: unidentified-50056f80-fixed-gas-recovery
title: "Unverified contract 0x70ba86…: under EIP-8151 every valid signature fails on activation day"
project: unidentified-50056f80
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x70ba86401368e64108368671fa3b7ff73db6128d"
  name: "unverified code (study family 63b4ed49)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 63b4ed49"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x70ba86401368e64108368671fa3b7ff73db6128d` (unverified, family `63b4ed49`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
