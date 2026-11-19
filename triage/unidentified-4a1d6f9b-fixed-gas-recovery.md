---
id: unidentified-4a1d6f9b-fixed-gas-recovery
title: "2 contract families (3 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-4a1d6f9b
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x9307f4893416dce16ffd85171db3e6d3f0c290b8"
  name: "unverified code (study family 0d5270b8)"
  upgradeable: "unknown"
- address: "0x5ba98b652a2fae619f173fe680eacf7358cd1eda"
  name: "unverified code (study family 589554c0), 1 of 2 addresses running it"
  upgradeable: "unknown"
families:
- code: "0x5ba98b652a2fae619f173fe680eacf7358cd1eda"
  name: "unverified code (study family 589554c0)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 0d5270b8, 589554c0"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 3 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x9307f4893416dce16ffd85171db3e6d3f0c290b8` (unverified, family `0d5270b8`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x5ba98b652a2fae619f173fe680eacf7358cd1eda` (unverified, family `589554c0`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
