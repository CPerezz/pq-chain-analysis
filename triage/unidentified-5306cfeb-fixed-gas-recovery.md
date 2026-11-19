---
id: unidentified-5306cfeb-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-5306cfeb
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x5a15b2d328723e400776cc502ea41cd58ae771e0"
  name: "unverified code (study family 2ef2dd1d)"
  upgradeable: "unknown"
- address: "0x75eee2b5ffea02f1e14e6a1c40bd30ca94cff975"
  name: "Game (study family cca51326)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 2ef2dd1d, cca51326"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x5a15b2d328723e400776cc502ea41cd58ae771e0` (unverified, family `2ef2dd1d`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x75eee2b5ffea02f1e14e6a1c40bd30ca94cff975` (Game, family `cca51326`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
