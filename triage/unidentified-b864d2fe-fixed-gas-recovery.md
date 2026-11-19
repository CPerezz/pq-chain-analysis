---
id: unidentified-b864d2fe-fixed-gas-recovery
title: "Oracle: under EIP-8151 every valid signature fails on activation day"
project: unidentified-b864d2fe
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x634ab8f3f791a905b6e6ea72c33483401ed56e6b"
  name: "Oracle (study family 60ccf699)"
  upgradeable: "unknown"
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 60ccf699"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $902 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x634ab8f3f791a905b6e6ea72c33483401ed56e6b` (Oracle, family `60ccf699`, 1 address, $902): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
