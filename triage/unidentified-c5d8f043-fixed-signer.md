---
id: unidentified-c5d8f043-fixed-signer
title: "testpay_local_unlimit: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-c5d8f043
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb1b2c3fda82979fa5639a334f695f5ff9f46395f"
  name: "testpay_local_unlimit (study family 5584044d)"
  upgradeable: "no"
  value_usd: 3068
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 5584044d"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 1 address, $3k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xb1b2c3fda82979fa5639a334f695f5ff9f46395f` (testpay_local_unlimit, family `5584044d`, 1 address, $3k): testpay: deposits (attend) leave only through unattend, which needs a signature of the constant address 0xc5D8f043b6a4983C8C2EE6A1eD5ca6bd35007A83; if that account takes code nothing can leave. Decided by: read.
