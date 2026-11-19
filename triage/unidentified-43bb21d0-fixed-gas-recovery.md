---
id: unidentified-43bb21d0-fixed-gas-recovery
title: "GreenRabbitInvader: under EIP-8151 every valid signature fails on activation day"
project: unidentified-43bb21d0
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x76d7aed5ab1c4a5e210d0ccac747d097f9d58966"
  name: "GreenRabbitInvader (study family 1301cfe3)"
  upgradeable: "unknown"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 1301cfe3"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $180 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x76d7aed5ab1c4a5e210d0ccac747d097f9d58966` (GreenRabbitInvader, family `1301cfe3`, 1 address, $180): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
