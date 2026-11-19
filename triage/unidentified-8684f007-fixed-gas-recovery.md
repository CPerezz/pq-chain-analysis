---
id: unidentified-8684f007-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-8684f007
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x28acf73120a256bae770f0249be20a46f18ee314"
  name: "R (study family f817c246)"
  upgradeable: "unknown"
- address: "0xbdef30be17d478d9bebc38fab5b8be80831f7926"
  name: "R (study family dd9690f7)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f817c246, dd9690f7"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x28acf73120a256bae770f0249be20a46f18ee314` (R, family `f817c246`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xbdef30be17d478d9bebc38fab5b8be80831f7926` (R, family `dd9690f7`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
