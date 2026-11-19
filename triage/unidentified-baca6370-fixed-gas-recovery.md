---
id: unidentified-baca6370-fixed-gas-recovery
title: "Crowdsale: under EIP-8151 every valid signature fails on activation day"
project: unidentified-baca6370
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x07c4ff9ce6fe629d41a091b047629427caf4f342"
  name: "Crowdsale (study family 2dbb4f92)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 2dbb4f92"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x07c4ff9ce6fe629d41a091b047629427caf4f342` (Crowdsale, family `2dbb4f92`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
