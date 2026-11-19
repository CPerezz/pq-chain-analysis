---
id: unidentified-45e9cfa7-fixed-gas-recovery
title: "Unverified contract 0xe1813a…: under EIP-8151 every valid signature fails on activation day"
project: unidentified-45e9cfa7
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xe1813a8da9027e3d5c2d714cb7cde74350117a81"
  name: "unverified code (study family ab2c7d38)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families ab2c7d38"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xe1813a8da9027e3d5c2d714cb7cde74350117a81` (unverified, family `ab2c7d38`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
