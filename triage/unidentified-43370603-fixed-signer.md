---
id: unidentified-43370603-fixed-signer
title: "Unverified contract 0x072aae…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-43370603
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x072aaea048994c6124a1cc9f23e27e72adbb3ba0"
  name: "unverified code (study family a0da3964)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families a0da3964"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x072aaea048994c6124a1cc9f23e27e72adbb3ba0` (unverified, family `a0da3964`, 1 address, $0): account whose signer is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
