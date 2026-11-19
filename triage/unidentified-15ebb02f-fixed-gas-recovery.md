---
id: unidentified-15ebb02f-fixed-gas-recovery
title: "abcLottoController: under EIP-8151 every valid signature fails on activation day"
project: unidentified-15ebb02f
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xb3030869cb6f67502ce592be2419bb948448bf56"
  name: "abcLottoController (study family 86299e03)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 86299e03"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xb3030869cb6f67502ce592be2419bb948448bf56` (abcLottoController, family `86299e03`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
