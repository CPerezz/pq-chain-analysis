---
id: unidentified-f8b432f0-fixed-signer
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-f8b432f0
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x81f29e8d5a6f4f86755746c74393a1467b821d45"
  name: "unverified code (study family db6bf23c), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x81f29e8d5a6f4f86755746c74393a1467b821d45"
  name: "unverified code (study family db6bf23c)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families db6bf23c"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x81f29e8d5a6f4f86755746c74393a1467b821d45` (unverified, family `db6bf23c`, 2 addresses, $0): account with six selectors: one stored owner key and no function to change it. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
