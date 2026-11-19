---
id: unidentified-a3dd533b-fixed-signer
title: "Unverified contract 0x01107c…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-a3dd533b
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x01107c2d5d147f02ee90746fbad4f5061696b5f2"
  name: "unverified code (study family d867637e)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families d867637e"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x01107c2d5d147f02ee90746fbad4f5061696b5f2` (unverified, family `d867637e`, 1 address, $0): listings co-signed by an authorisation signer that is a constant in the code. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code, before any recovery returned nothing: the code changed…
