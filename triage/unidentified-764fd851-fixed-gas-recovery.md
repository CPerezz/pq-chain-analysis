---
id: unidentified-764fd851-fixed-gas-recovery
title: "Unverified contract 0x7e5cb2…: under EIP-8151 every valid signature fails on activation day"
project: unidentified-764fd851
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x7e5cb2a2b9c64872d64320bf5bcb8de8c16773a1"
  name: "unverified code (study family 5db33ad9)"
  upgradeable: "unknown"
  value_usd: 1624
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 5db33ad9"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $2k held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x7e5cb2a2b9c64872d64320bf5bcb8de8c16773a1` (unverified, family `5db33ad9`, 1 address, $2k): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
