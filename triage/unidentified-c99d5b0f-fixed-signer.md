---
id: unidentified-c99d5b0f-fixed-signer
title: "NativePmmAntiToxicAdapterV6: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-c99d5b0f
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x47501b19d6db513308d126a3460382cdc61ab3a7"
  name: "NativePmmAntiToxicAdapterV6 (study family bfe89089)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families bfe89089"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x47501b19d6db513308d126a3460382cdc61ab3a7` (NativePmmAntiToxicAdapterV6, family `bfe89089`, 1 address, $0): CallerAuth (variant): the signer must be AUTH_SIGNER, fixed in the code. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
