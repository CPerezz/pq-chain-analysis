---
id: unidentified-649c43ac-fixed-signer
title: "Unverified contract 0x2d69dd…: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-649c43ac
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x2d69dd366f185deaafb3292683fc3eef95b0e0d2"
  name: "unverified code (study family e1b06d61)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families e1b06d61"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x2d69dd366f185deaafb3292683fc3eef95b0e0d2` (unverified, family `e1b06d61`, 1 address, $0): four selectors; one stored signer, no setter. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
