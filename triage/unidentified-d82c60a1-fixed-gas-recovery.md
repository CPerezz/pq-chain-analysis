---
id: unidentified-d82c60a1-fixed-gas-recovery
title: "Unverified contract 0xc572b3…: under EIP-8151 every valid signature fails on activation day"
project: unidentified-d82c60a1
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xc572b36e72933182a4c05f94df518cbbe10f335b"
  name: "unverified code (study family 89ce10ee)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 89ce10ee"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xc572b36e72933182a4c05f94df518cbbe10f335b` (unverified, family `89ce10ee`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
