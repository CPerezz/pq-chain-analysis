---
id: unidentified-4c7fba3d-fixed-gas-recovery
title: "Unverified contract 0xa68a8e…: under EIP-8151 every valid signature fails on activation day"
project: unidentified-4c7fba3d
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xa68a8ed8d7ed0589cc2dc1a4aae45a0ba3022522"
  name: "unverified code (study family 033c5deb)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 033c5deb"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xa68a8ed8d7ed0589cc2dc1a4aae45a0ba3022522` (unverified, family `033c5deb`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
