---
id: unidentified-dcab943e-fixed-gas-recovery
title: "Unverified contract 0xf06703…: under EIP-8151 every valid signature fails on activation day"
project: unidentified-dcab943e
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xf067031675997b0a1d576bedc8fca65dc8f9353f"
  name: "unverified code (study family 9acbfa04)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 9acbfa04"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xf067031675997b0a1d576bedc8fca65dc8f9353f` (unverified, family `9acbfa04`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
