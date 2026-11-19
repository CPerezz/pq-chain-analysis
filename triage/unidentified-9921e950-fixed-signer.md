---
id: unidentified-9921e950-fixed-signer
title: "SignedPriceAdapter (90 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-9921e950
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb98137ced805a2b2773033da14afbb7ef5d09947"
  name: "SignedPriceAdapter (study family 5317f1d0), 1 of 90 addresses running it"
  upgradeable: "no"
families:
- code: "0xb98137ced805a2b2773033da14afbb7ef5d09947"
  name: "SignedPriceAdapter (study family 5317f1d0)"
  instances: 90
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 5317f1d0"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 90 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xb98137ced805a2b2773033da14afbb7ef5d09947` (SignedPriceAdapter, family `5317f1d0`, 90 addresses, $0): SignedPriceAdapter: the signer must be `signer`, fixed in the code. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
