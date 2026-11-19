---
id: unidentified-b1a7fe27-fixed-gas-recovery
title: "3 contract families (4 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-b1a7fe27
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xc25bd2d532cc424af60e631acc292b3142ccf197"
  name: "unverified code (study family cb29fcb8), 1 of 2 addresses running it"
  upgradeable: "unknown"
- address: "0x51a46d6f029bd7da36b16ea78baca80b2c447059"
  name: "HEXLOTTO (study family b2af0ab7)"
  upgradeable: "unknown"
- address: "0x416bce1aaeb6b46f4b67d72d3707a92c480544f1"
  name: "unverified code (study family 1ad5158a)"
  upgradeable: "unknown"
families:
- code: "0xc25bd2d532cc424af60e631acc292b3142ccf197"
  name: "unverified code (study family cb29fcb8)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families cb29fcb8, b2af0ab7, 1ad5158a"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 3 code families, 4 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xc25bd2d532cc424af60e631acc292b3142ccf197` (unverified, family `cb29fcb8`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x51a46d6f029bd7da36b16ea78baca80b2c447059` (HEXLOTTO, family `b2af0ab7`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x416bce1aaeb6b46f4b67d72d3707a92c480544f1` (unverified, family `1ad5158a`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
