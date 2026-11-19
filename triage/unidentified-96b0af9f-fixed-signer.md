---
id: unidentified-96b0af9f-fixed-signer
title: "Unverified contract 0xdc32a7…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-96b0af9f
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xdc32a78d3868be38a9a047a93c238f6981d2b16d"
  name: "unverified code (study family 107cc427)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 107cc427"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xdc32a78d3868be38a9a047a93c238f6981d2b16d` (unverified, family `107cc427`, 1 address, $0): three selectors; the recovered address is compared with one stored address; no function to replace it. Decided by: bytecode and names (no source).
