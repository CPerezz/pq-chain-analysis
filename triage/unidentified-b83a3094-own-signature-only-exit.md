---
id: unidentified-b83a3094-own-signature-only-exit
title: "Unverified contract 0x7410dc…: under EIP-8151 a party whose account has code can no longer act on its funds"
project: unidentified-b83a3094
status: candidate
severity: CRITICAL
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0x7410dc72ea112a7b09e9380fd602836370cfe031"
  name: "unverified code (study family 3936b80d)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 3936b80d"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract lets a party act on its funds or rights only with its own ECDSA signature. 1 code family, 1 address, $0 held. To settle the rating: is a direct way out missing for every party.

## Evidence

- `0x7410dc72ea112a7b09e9380fd602836370cfe031` (unverified, family `3936b80d`, 1 address, $0): Panther zAccount registration: the zAccount's master EOA is whatever address the registration signature recovers to (no ERC-1271, the caller does not count). An account with code can never be registered as a master EOA;… Decided by: read.
