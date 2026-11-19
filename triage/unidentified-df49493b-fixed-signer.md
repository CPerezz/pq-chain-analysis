---
id: unidentified-df49493b-fixed-signer
title: "Unverified contract 0x345960…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-df49493b
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x3459608da9ae247690e78e8562d9064a0e00418b"
  name: "unverified code (study family dc151f42)"
  upgradeable: "no"
  value_usd: 7038
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families dc151f42"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $7k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x3459608da9ae247690e78e8562d9064a0e00418b` (unverified, family `dc151f42`, 1 address, $7k): mint behind a signer that is a constant in the code. Decided by: bytecode and names (no source).
