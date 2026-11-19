---
id: unidentified-35ea00b5-fixed-gas-recovery
title: "84 unverified contracts with one code: under EIP-8151 every valid signature fails on activation day"
project: unidentified-35ea00b5
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xce5b4d4883d3886b38853d4942984a1a6870392b"
  name: "unverified code (study family 2804e3b9), 1 of 84 addresses running it"
  upgradeable: "no"
families:
- code: "0xce5b4d4883d3886b38853d4942984a1a6870392b"
  name: "unverified code (study family 2804e3b9)"
  instances: 84
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 12091
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 2804e3b9"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 84 addresses, $12k held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xce5b4d4883d3886b38853d4942984a1a6870392b` (unverified, family `2804e3b9`, 84 addresses, $12k): the signer is one key kept in storage; functions replace it (changeAllCosigners). Whoever holds it must replace it before that account takes code. Decided by: rule.
