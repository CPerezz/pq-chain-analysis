---
id: unidentified-5f7efa06-fixed-gas-recovery
title: "DrawTicket (2 copies): under EIP-8151 every valid signature fails on activation day"
project: unidentified-5f7efa06
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x18dd9ae3383de623db1ea37d8da5dde1dc74d356"
  name: "DrawTicket (study family 0ad1d896), 1 of 2 addresses running it"
  upgradeable: "unknown"
families:
- code: "0x18dd9ae3383de623db1ea37d8da5dde1dc74d356"
  name: "DrawTicket (study family 0ad1d896)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
  value_usd: 1083
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 0ad1d896"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 2 addresses, $1k held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x18dd9ae3383de623db1ea37d8da5dde1dc74d356` (DrawTicket, family `0ad1d896`, 2 addresses, $1k): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
