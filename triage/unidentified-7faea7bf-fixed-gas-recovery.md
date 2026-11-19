---
id: unidentified-7faea7bf-fixed-gas-recovery
title: "180 unverified contracts with one code: under EIP-8151 every valid signature fails on activation day"
project: unidentified-7faea7bf
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x4225d04ea2e2235e6dd15062d004a0cc769b6ad0"
  name: "unverified code (study family 8f8e6911), 1 of 180 addresses running it"
  upgradeable: "no"
families:
- code: "0x4225d04ea2e2235e6dd15062d004a0cc769b6ad0"
  name: "unverified code (study family 8f8e6911)"
  instances: 180
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 32121
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 8f8e6911"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 180 addresses, $32k held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x4225d04ea2e2235e6dd15062d004a0cc769b6ad0` (unverified, family `8f8e6911`, 180 addresses, $32k): the signer is one key kept in storage; functions replace it (changeAllCosigners). Whoever holds it must replace it before that account takes code. Decided by: rule.
