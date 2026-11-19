---
id: unidentified-20f1da6b-fixed-signer
title: "OpenDAO: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-20f1da6b
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x3b484b82567a09e2588a13d54d032153f0c0aee0"
  name: "OpenDAO (study family f2c77622)"
  upgradeable: "no"
  value_usd: 25444
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f2c77622"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $25k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x3b484b82567a09e2588a13d54d032153f0c0aee0` (OpenDAO, family `f2c77622`, 1 address, $25k): OpenDAO claim: signed by cSigner, fixed in the code. Decided by: read (function text).
