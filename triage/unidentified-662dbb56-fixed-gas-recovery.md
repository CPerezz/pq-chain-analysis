---
id: unidentified-662dbb56-fixed-gas-recovery
title: "Unverified contract 0xca09b7…: under EIP-8151 every valid signature fails on activation day"
project: unidentified-662dbb56
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xca09b7f77739c9c7868d20f8e3c7965321549746"
  name: "unverified code (study family 8bb3d5ff)"
  upgradeable: "unknown"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 8bb3d5ff"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $180 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xca09b7f77739c9c7868d20f8e3c7965321549746` (unverified, family `8bb3d5ff`, 1 address, $180): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
