---
id: unidentified-915c517c-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-915c517c
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x866f7a9f6190af5641b72f4e2e3bfdb9d8babc50"
  name: "UBets (study family 6f6ff7d7)"
  upgradeable: "unknown"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0x7ce60454cbc942a9003a7774f79949c05bb6d364"
  name: "UBets (study family 5375ec9f)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 6f6ff7d7, 5375ec9f"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $180 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x866f7a9f6190af5641b72f4e2e3bfdb9d8babc50` (UBets, family `6f6ff7d7`, 1 address, $180): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x7ce60454cbc942a9003a7774f79949c05bb6d364` (UBets, family `5375ec9f`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
