---
id: unidentified-8c9bb9c5-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-8c9bb9c5
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x880928e59a4ef3e3bb22e596f17081fd19e494c1"
  name: "Lottery (study family 98318810)"
  upgradeable: "unknown"
- address: "0xe16a567ea438a81994ec7859b9abb0184f3d6028"
  name: "Lottery (study family 6456d120)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 98318810, 6456d120"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x880928e59a4ef3e3bb22e596f17081fd19e494c1` (Lottery, family `98318810`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xe16a567ea438a81994ec7859b9abb0184f3d6028` (Lottery, family `6456d120`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
