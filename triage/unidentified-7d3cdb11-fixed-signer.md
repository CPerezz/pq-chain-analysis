---
id: unidentified-7d3cdb11-fixed-signer
title: "StakingManager: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-7d3cdb11
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xa1c4d914ce176df69fa94bb6be8422e2582cfd0b"
  name: "StakingManager (study family cb483ac5)"
  upgradeable: "no"
  value_usd: 20031
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families cb483ac5"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $20k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xa1c4d914ce176df69fa94bb6be8422e2582cfd0b` (StakingManager, family `cb483ac5`, 1 address, $20k): StakingManager withdraw: signed by signOwner_, a stored address; no function among its names changes it / StakingManager._recover: returns the signer. Decided by: read (function text).
