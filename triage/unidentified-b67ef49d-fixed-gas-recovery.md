---
id: unidentified-b67ef49d-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-b67ef49d
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xfdb988de142cb0bb7eaaff108846007ba88e9f8c"
  name: "unverified code (study family 64a19c5a)"
  upgradeable: "unknown"
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x1b9425267798105071e5f53c1358192be0eeff02"
  name: "unverified code (study family c11af237)"
  upgradeable: "unknown"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 64a19c5a, c11af237"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $541 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xfdb988de142cb0bb7eaaff108846007ba88e9f8c` (unverified, family `64a19c5a`, 1 address, $361): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x1b9425267798105071e5f53c1358192be0eeff02` (unverified, family `c11af237`, 1 address, $180): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
