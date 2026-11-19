---
id: unidentified-841542bd-fixed-signer
title: "Helmets2117: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-841542bd
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc708eae3292173aa57c78d7d5ee123aed9b6dc1a"
  name: "Helmets2117 (study family f453c892)"
  upgradeable: "no"
  value_usd: 4150
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f453c892"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $4k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xc708eae3292173aa57c78d7d5ee123aed9b6dc1a` (Helmets2117, family `f453c892`, 1 address, $4k): Helmets2117: signed by SIGNER_ADDRESS, fixed in the code. Decided by: read (function text).
