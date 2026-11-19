---
id: unidentified-3710c266-fixed-gas-recovery
title: "CyclicSpace: under EIP-8151 every valid signature fails on activation day"
project: unidentified-3710c266
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x2d8b986c7a2e450e994f0c1d97442c69fe4a4246"
  name: "CyclicSpace (study family 5a089378)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 5a089378"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x2d8b986c7a2e450e994f0c1d97442c69fe4a4246` (CyclicSpace, family `5a089378`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
