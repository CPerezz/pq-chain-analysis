---
id: unidentified-6a1e11e8-fixed-gas-recovery
title: "3 contract families (5 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-6a1e11e8
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x2c484e7f74fe49380d6ccbbb1be4f428c31c8290"
  name: "unverified code (study family d2867922), 1 of 2 addresses running it"
  upgradeable: "unknown"
- address: "0xa543d0ec7f52996684daed1552a70e0e84c962a3"
  name: "unverified code (study family fa182753), 1 of 2 addresses running it"
  upgradeable: "unknown"
- address: "0xf31cfb17f14cc8ef33fb4a0717d87f5a37c0ee69"
  name: "unverified code (study family a711cde4)"
  upgradeable: "unknown"
families:
- code: "0x2c484e7f74fe49380d6ccbbb1be4f428c31c8290"
  name: "unverified code (study family d2867922)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xa543d0ec7f52996684daed1552a70e0e84c962a3"
  name: "unverified code (study family fa182753)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families d2867922, fa182753, a711cde4"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 3 code families, 5 addresses, $541 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x2c484e7f74fe49380d6ccbbb1be4f428c31c8290` (unverified, family `d2867922`, 2 addresses, $541): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xa543d0ec7f52996684daed1552a70e0e84c962a3` (unverified, family `fa182753`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xf31cfb17f14cc8ef33fb4a0717d87f5a37c0ee69` (unverified, family `a711cde4`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
