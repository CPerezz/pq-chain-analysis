---
id: unidentified-cad8a012-fixed-signer
title: "VerifyingPaymaster (9 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-cad8a012
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xbd549aca7ef43ae8d2872292adb52cf045707412"
  name: "VerifyingPaymaster (study family 16c5cbb6), 1 of 9 addresses running it"
  upgradeable: "no"
families:
- code: "0xbd549aca7ef43ae8d2872292adb52cf045707412"
  name: "VerifyingPaymaster (study family 16c5cbb6)"
  instances: 9
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 16c5cbb6"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 9 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xbd549aca7ef43ae8d2872292adb52cf045707412` (VerifyingPaymaster, family `16c5cbb6`, 9 addresses, $0): VerifyingPaymaster: the signer must be verifyingSigner, fixed in the code. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
