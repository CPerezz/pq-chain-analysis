---
id: unidentified-c25fce14-fixed-gas-recovery
title: "4 contract families (4 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-c25fce14
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x6c34ade33c183fedeff205e8d2f52cf924b879b5"
  name: "unverified code (study family ffe7d483)"
  upgradeable: "unknown"
- address: "0xf3fc3d7b0761f43f410b44e8bf871a8f3a026b50"
  name: "unverified code (study family 4def7860)"
  upgradeable: "unknown"
- address: "0xaef17ac4ac6534a31a765095fc4cb00acfe5319a"
  name: "unverified code (study family aaf6983a)"
  upgradeable: "unknown"
- address: "0x4459bdac55c2b9484d013802b4cae1724551d787"
  name: "unverified code (study family fb1bdee2)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families ffe7d483, 4def7860, aaf6983a, fb1bdee2"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 4 code families, 4 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x6c34ade33c183fedeff205e8d2f52cf924b879b5` (unverified, family `ffe7d483`, 1 address, $0): 5000 gas to the precompile: fails when the recovered address is cold. Decided by: scanner facts.
- `0xf3fc3d7b0761f43f410b44e8bf871a8f3a026b50` (unverified, family `4def7860`, 1 address, $0): 5000 gas to the precompile: fails when the recovered address is cold. Decided by: scanner facts.
- `0xaef17ac4ac6534a31a765095fc4cb00acfe5319a` (unverified, family `aaf6983a`, 1 address, $0): 5000 gas to the precompile: fails when the recovered address is cold. Decided by: scanner facts.
- `0x4459bdac55c2b9484d013802b4cae1724551d787` (unverified, family `fb1bdee2`, 1 address, $0): 5000 gas to the precompile: fails when the recovered address is cold. Decided by: scanner facts.
