---
id: unidentified-0bc6e9f2-fixed-signer
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-0bc6e9f2
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xba412d8b36bfd7d65dff5cc0df7b3c29a7eae687"
  name: "unverified code (study family 9e1a9c30), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0xba412d8b36bfd7d65dff5cc0df7b3c29a7eae687"
  name: "unverified code (study family 9e1a9c30)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 9e1a9c30"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xba412d8b36bfd7d65dff5cc0df7b3c29a7eae687` (unverified, family `9e1a9c30`, 2 addresses, $0): swap executor: one stored signer, no function name that changes it; the operator's own key. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
