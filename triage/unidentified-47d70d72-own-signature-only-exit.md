---
id: unidentified-47d70d72-own-signature-only-exit
title: "LocalCryptosETHEscrows: under EIP-8151 a party whose account has code can no longer act on its funds"
project: unidentified-47d70d72
status: candidate
severity: CRITICAL
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0xede26ccc85ae521d06b5ef2604952a421c9124b6"
  name: "LocalCryptosETHEscrows (study family 946542f8)"
  upgradeable: "no"
  value_usd: 6136
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 946542f8"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract lets a party act on its funds or rights only with its own ECDSA signature. 1 code family, 1 address, $6k held. To settle the rating: is a direct way out missing for every party.

## Evidence

- `0xede26ccc85ae521d06b5ef2604952a421c9124b6` (LocalCryptosETHEscrows, family `946542f8`, 1 address, $6k): LocalCryptos ETH escrow: a dispute can be resolved only with a signature of the buyer or of the seller. Decided by: read.
