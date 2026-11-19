---
id: unidentified-4468bab1-fixed-gas-recovery
title: "BONUSROLL: under EIP-8151 every valid signature fails on activation day"
project: unidentified-4468bab1
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x46403e94529fc04d04c9c393beab1d050ef06409"
  name: "BONUSROLL (study family ec48e906)"
  upgradeable: "no"
  value_usd: 41505
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families ec48e906"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 1 code family, 1 address, $42k held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x46403e94529fc04d04c9c393beab1d050ef06409` (BONUSROLL, family `ec48e906`, 1 address, $42k): Oraclize verifySig (variant): the recovered address must be the address of the public key carried in the proof; the result flag is ignored / Oraclize safer_ecrecover: a constant 3,000 gas to the precompile; returns what… Decided by: read (function text).
