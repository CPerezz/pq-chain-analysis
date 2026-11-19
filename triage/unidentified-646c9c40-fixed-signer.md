---
id: unidentified-646c9c40-fixed-signer
title: "ChosenOnes: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-646c9c40
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x4f17e8e976b809408d4aa3485bff9326df8ab505"
  name: "ChosenOnes (study family a805b06e)"
  upgradeable: "no"
  value_usd: 2887
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families a805b06e"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $3k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x4f17e8e976b809408d4aa3485bff9326df8ab505` (ChosenOnes, family `a805b06e`, 1 address, $3k): ChosenOnes presale: signed by SIGNER, fixed in the code. Decided by: read (function text).
