---
id: unidentified-b7bc72a8-fixed-signer
title: "Multisender (2 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-b7bc72a8
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x3845fa0348d45284a4c5041195353b08091915c8"
  name: "Multisender (study family f676074f), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x3845fa0348d45284a4c5041195353b08091915c8"
  name: "Multisender (study family f676074f)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f676074f"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x3845fa0348d45284a4c5041195353b08091915c8` (Multisender, family `f676074f`, 2 addresses, $0): Multisender: exactly two signatures, from two addresses fixed in the code. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
