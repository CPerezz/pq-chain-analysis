---
id: unidentified-43374722-fixed-signer
title: "Unverified contract 0xa2b6f2…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-43374722
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xa2b6f21d10118aac0c74f8e4df4195b6d26b4e0b"
  name: "unverified code (study family d03aafa2)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families d03aafa2"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xa2b6f21d10118aac0c74f8e4df4195b6d26b4e0b` (unverified, family `d03aafa2`, 1 address, $0): account whose signer is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
