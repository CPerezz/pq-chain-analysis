---
id: unidentified-9a9236da-fixed-gas-recovery
title: "Bitlagio: under EIP-8151 every valid signature fails on activation day"
project: unidentified-9a9236da
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec"
  name: "Bitlagio (study family e7a57a7c)"
  upgradeable: "no"
  value_usd: 4692
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families e7a57a7c"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $5k held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec` (Bitlagio, family `e7a57a7c`, 1 address, $5k): Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a constant 3,000 gas to the precompile;… Decided by: read (function text).
