---
id: unidentified-a46c19fa-fixed-gas-recovery
title: "5 contract families (5 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-a46c19fa
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xff153aaab90deb8d88c3e7e9e0737b03a5e8b93c"
  name: "unverified code (study family dbf78ecb)"
  upgradeable: "unknown"
- address: "0x767c8bb1574bee5d4fe35e27e0003c89d43c5121"
  name: "unverified code (study family 970ef5c4)"
  upgradeable: "unknown"
- address: "0xa6bd54f6ded7f0d1e2c7bdc87399efe88926e9ba"
  name: "unverified code (study family 03474c18)"
  upgradeable: "unknown"
- address: "0x0773edc0438b2ef18fc535b21d0ac77912c308c0"
  name: "unverified code (study family 5b08058a)"
  upgradeable: "unknown"
- address: "0xe35f24470730f5a488da9721548c1ab0b65b53d5"
  name: "unverified code (study family d39bccb3)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families dbf78ecb, 970ef5c4, 03474c18, 5b08058a, d39bccb3"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 5 code families, 5 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xff153aaab90deb8d88c3e7e9e0737b03a5e8b93c` (unverified, family `dbf78ecb`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x767c8bb1574bee5d4fe35e27e0003c89d43c5121` (unverified, family `970ef5c4`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xa6bd54f6ded7f0d1e2c7bdc87399efe88926e9ba` (unverified, family `03474c18`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x0773edc0438b2ef18fc535b21d0ac77912c308c0` (unverified, family `5b08058a`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xe35f24470730f5a488da9721548c1ab0b65b53d5` (unverified, family `d39bccb3`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
