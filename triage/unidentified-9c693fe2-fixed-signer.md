---
id: unidentified-9c693fe2-fixed-signer
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-9c693fe2
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc8b7d105b4e4ab8337c617249fed817861fe0851"
  name: "unverified code (study family 33a4a6d0), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0xc8b7d105b4e4ab8337c617249fed817861fe0851"
  name: "unverified code (study family 33a4a6d0)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 33a4a6d0"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xc8b7d105b4e4ab8337c617249fed817861fe0851` (unverified, family `33a4a6d0`, 2 addresses, $0): verifying paymaster: a signer that is a constant in the code. Decided by: bytecode and names (no source).
