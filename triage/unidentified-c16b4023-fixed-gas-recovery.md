---
id: unidentified-c16b4023-fixed-gas-recovery
title: "JungleScratch: under EIP-8151 every valid signature fails on activation day"
project: unidentified-c16b4023
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xc78c9d561cd66d1ab28cc0643a1941b93915629b"
  name: "JungleScratch (study family 031ef383)"
  upgradeable: "unknown"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 031ef383"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $541 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xc78c9d561cd66d1ab28cc0643a1941b93915629b` (JungleScratch, family `031ef383`, 1 address, $541): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
