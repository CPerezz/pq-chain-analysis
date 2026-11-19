---
id: unidentified-178370ac-fixed-gas-recovery
title: "2 contract families (2 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-178370ac
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xf17b52226d78070696ff2dddcb08bb65986054e1"
  name: "unverified code (study family 7c83e46c)"
  upgradeable: "unknown"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xbb936398c3c06f93a229f807a96236d0763889d4"
  name: "unverified code (study family 9572fd95)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 7c83e46c, 9572fd95"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 2 addresses, $180 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xf17b52226d78070696ff2dddcb08bb65986054e1` (unverified, family `7c83e46c`, 1 address, $180): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xbb936398c3c06f93a229f807a96236d0763889d4` (unverified, family `9572fd95`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
