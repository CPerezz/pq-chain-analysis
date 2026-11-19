---
id: unidentified-346dba8b-fixed-signer
title: "2 contract families (293 addresses): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-346dba8b
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb611cd365ac6c1b9e156101554c778971629ce9b"
  name: "unverified code (study family 5b3f8b1f), 1 of 156 addresses running it"
  upgradeable: "no"
- address: "0xb6076ef9e8d55845f135324cc447a5986bcebe21"
  name: "unverified code (study family 9fcc3583), 1 of 137 addresses running it"
  upgradeable: "no"
families:
- code: "0xb611cd365ac6c1b9e156101554c778971629ce9b"
  name: "unverified code (study family 5b3f8b1f)"
  instances: 156
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
- code: "0xb6076ef9e8d55845f135324cc447a5986bcebe21"
  name: "unverified code (study family 9fcc3583)"
  instances: 137
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 5b3f8b1f, 9fcc3583"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 2 code families, 293 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xb611cd365ac6c1b9e156101554c778971629ce9b` (unverified, family `5b3f8b1f`, 156 addresses, $0): 156 contracts: a signer that is a constant in the code. Decided by: bytecode and names (no source).
- `0xb6076ef9e8d55845f135324cc447a5986bcebe21` (unverified, family `9fcc3583`, 137 addresses, $0): 137 contracts: a signer that is a constant in the code. Decided by: bytecode and names (no source).
