---
id: unidentified-fd97b6d9-fixed-gas-recovery
title: "Unverified contract 0x736d9b…: under EIP-8151 every valid signature fails on activation day"
project: unidentified-fd97b6d9
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x736d9b6a58ab142e9ea171fb9cb5c401decbe1d0"
  name: "unverified code (study family 9a87ef81)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 9a87ef81"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x736d9b6a58ab142e9ea171fb9cb5c401decbe1d0` (unverified, family `9a87ef81`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
