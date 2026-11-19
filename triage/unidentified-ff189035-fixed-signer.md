---
id: unidentified-ff189035-fixed-signer
title: "Presale: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-ff189035
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb5f2b7d8936cc1455b23b178fdb053591996af27"
  name: "Presale (study family 80af2596)"
  upgradeable: "no"
  value_usd: 50528
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 80af2596"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $51k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xb5f2b7d8936cc1455b23b178fdb053591996af27` (Presale, family `80af2596`, 1 address, $51k): Presale: deposit and claim need a signature of SIGNER, fixed in the code. Decided by: read (function text).
