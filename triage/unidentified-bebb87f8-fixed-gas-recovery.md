---
id: unidentified-bebb87f8-fixed-gas-recovery
title: "BigFishRoll: under EIP-8151 every valid signature fails on activation day"
project: unidentified-bebb87f8
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x7e2743451b1f3d2849e44cf67164bfe4538fd0f1"
  name: "BigFishRoll (study family b4e07d27)"
  upgradeable: "unknown"
  value_usd: 722
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b4e07d27"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $722 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x7e2743451b1f3d2849e44cf67164bfe4538fd0f1` (BigFishRoll, family `b4e07d27`, 1 address, $722): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
