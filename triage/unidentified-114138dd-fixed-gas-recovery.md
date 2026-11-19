---
id: unidentified-114138dd-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-114138dd
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xfc637df69fbeceff245a20053764674ace313398"
  name: "RandomExample (study family 59fa8e3b)"
  upgradeable: "unknown"
- address: "0x11832c44e8bebb07319243c905653959138c9f9a"
  name: "unverified code (study family 791c305f)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 59fa8e3b, 791c305f"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xfc637df69fbeceff245a20053764674ace313398` (RandomExample, family `59fa8e3b`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x11832c44e8bebb07319243c905653959138c9f9a` (unverified, family `791c305f`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
