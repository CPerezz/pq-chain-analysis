---
id: unidentified-a12b36b3-fixed-signer
title: "ClipperVerifiedCaravelExchange: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-a12b36b3
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xe7b0ce0526fbe3969035a145c9e9691d4d9d216c"
  name: "ClipperVerifiedCaravelExchange (study family 21a25b21)"
  upgradeable: "no"
  value_usd: 7399
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 21a25b21"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $7k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xe7b0ce0526fbe3969035a145c9e9691d4d9d216c` (ClipperVerifiedCaravelExchange, family `21a25b21`, 1 address, $7k): Clipper (verified variant): signed by DESIGNATED_SIGNER, fixed in the code. Decided by: read (function text).
