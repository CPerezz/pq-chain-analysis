---
id: unidentified-9ffc7dc1-fixed-gas-recovery
title: "2 contract families (4 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-9ffc7dc1
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x21594a9ce1c290915242e6aa9c8d29c34eb7f9eb"
  name: "SilverRaffle (study family d75f15fc), 1 of 3 addresses running it"
  upgradeable: "unknown"
- address: "0xbaca9c2faf03898fc5197ee90efb6e13df7f1d55"
  name: "ProgressiveRaffle (study family 435e61f6)"
  upgradeable: "unknown"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
families:
- code: "0x21594a9ce1c290915242e6aa9c8d29c34eb7f9eb"
  name: "SilverRaffle (study family d75f15fc)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families d75f15fc, 435e61f6"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 4 addresses, $541 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x21594a9ce1c290915242e6aa9c8d29c34eb7f9eb` (SilverRaffle, family `d75f15fc`, 3 addresses, $361): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xbaca9c2faf03898fc5197ee90efb6e13df7f1d55` (ProgressiveRaffle, family `435e61f6`, 1 address, $180): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
