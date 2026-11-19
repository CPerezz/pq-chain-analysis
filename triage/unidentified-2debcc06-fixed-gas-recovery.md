---
id: unidentified-2debcc06-fixed-gas-recovery
title: "3 contract families (4 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-2debcc06
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xf166415ca68929b315b25b0ada069fe317e39a0c"
  name: "unverified code (study family c90e330a)"
  upgradeable: "unknown"
- address: "0x55d9eaac40b58bf19405fac6fbd84cf5e09cc91e"
  name: "unverified code (study family 0fb4934e)"
  upgradeable: "unknown"
- address: "0x42b7c3dae45084fe3983725a70ec01ff4c05efed"
  name: "Raffle (study family 88ea0504), 1 of 2 addresses running it"
  upgradeable: "unknown"
families:
- code: "0x42b7c3dae45084fe3983725a70ec01ff4c05efed"
  name: "Raffle (study family 88ea0504)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c90e330a, 0fb4934e, 88ea0504"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 3 code families, 4 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xf166415ca68929b315b25b0ada069fe317e39a0c` (unverified, family `c90e330a`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x55d9eaac40b58bf19405fac6fbd84cf5e09cc91e` (unverified, family `0fb4934e`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x42b7c3dae45084fe3983725a70ec01ff4c05efed` (Raffle, family `88ea0504`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
