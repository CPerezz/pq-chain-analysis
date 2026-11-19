---
id: unidentified-c110b6e9-fixed-signer
title: "VerifyingPaymaster (27 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-c110b6e9
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xac758eaf83906d0677254fd8fbf6ca19ce5b7e7c"
  name: "VerifyingPaymaster (study family c24b5a05), 1 of 27 addresses running it"
  upgradeable: "no"
families:
- code: "0xac758eaf83906d0677254fd8fbf6ca19ce5b7e7c"
  name: "VerifyingPaymaster (study family c24b5a05)"
  instances: 27
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c24b5a05"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 27 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xac758eaf83906d0677254fd8fbf6ca19ce5b7e7c` (VerifyingPaymaster, family `c24b5a05`, 27 addresses, $0): VerifyingPaymaster: the signer must be verifyingSigner, fixed in the code. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
