---
id: unidentified-9c627eca-fixed-gas-recovery
title: "6 contract families (6 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-9c627eca
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x8cd2bbc42f030fffabf79de4f176980eed843fd3"
  name: "unverified code (study family 3de2af02)"
  upgradeable: "unknown"
- address: "0x639e250b6eb084e2b3575eaac76873221b431bbb"
  name: "unverified code (study family 1667d246)"
  upgradeable: "unknown"
- address: "0xbe87aff8814d4a465ad04c47ec2570ca9ef15b36"
  name: "unverified code (study family d28d294e)"
  upgradeable: "unknown"
- address: "0x16aa4c5a51042efeddc86dea4b454b085b4a80b2"
  name: "unverified code (study family 2f78e475)"
  upgradeable: "unknown"
- address: "0x249a7c08536211393fc3dd5323e70ae21a18368a"
  name: "unverified code (study family 25a441ad)"
  upgradeable: "unknown"
- address: "0x9c1f59bdddc90d65d3b47adb1069a1b257818493"
  name: "unverified code (study family a7aaf9e6)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 3de2af02, 1667d246, d28d294e, 2f78e475, 25a441ad, a7aaf9e6"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 6 code families, 6 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x8cd2bbc42f030fffabf79de4f176980eed843fd3` (unverified, family `3de2af02`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x639e250b6eb084e2b3575eaac76873221b431bbb` (unverified, family `1667d246`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xbe87aff8814d4a465ad04c47ec2570ca9ef15b36` (unverified, family `d28d294e`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x16aa4c5a51042efeddc86dea4b454b085b4a80b2` (unverified, family `2f78e475`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x249a7c08536211393fc3dd5323e70ae21a18368a` (unverified, family `25a441ad`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x9c1f59bdddc90d65d3b47adb1069a1b257818493` (unverified, family `a7aaf9e6`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
