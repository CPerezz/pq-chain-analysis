---
id: unidentified-8d912646-fixed-signer
title: "DaimoPayPricer (7 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-8d912646
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc167c11756823293f905af362e7cb870fb85e922"
  name: "DaimoPayPricer (study family 312db001), 1 of 7 addresses running it"
  upgradeable: "no"
families:
- code: "0xc167c11756823293f905af362e7cb870fb85e922"
  name: "DaimoPayPricer (study family 312db001)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 312db001"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 7 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xc167c11756823293f905af362e7cb870fb85e922` (DaimoPayPricer, family `312db001`, 7 addresses, $0): DaimoPay pricer: the signer must be trustedSigner, fixed in the code. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
