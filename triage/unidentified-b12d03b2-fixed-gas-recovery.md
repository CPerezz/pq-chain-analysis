---
id: unidentified-b12d03b2-fixed-gas-recovery
title: "Lottery (6 copies): under EIP-8151 every valid signature fails on activation day"
project: unidentified-b12d03b2
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xfd26e8e81c46bce1f0d0f86a3848bcd5c95fd9ac"
  name: "Lottery (study family 1d978b80), 1 of 6 addresses running it"
  upgradeable: "unknown"
families:
- code: "0xfd26e8e81c46bce1f0d0f86a3848bcd5c95fd9ac"
  name: "Lottery (study family 1d978b80)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 1d978b80"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 6 addresses, $180 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xfd26e8e81c46bce1f0d0f86a3848bcd5c95fd9ac` (Lottery, family `1d978b80`, 6 addresses, $180): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
