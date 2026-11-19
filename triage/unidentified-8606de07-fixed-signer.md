---
id: unidentified-8606de07-fixed-signer
title: "Fintoch (3,980 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-8606de07
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x37d62fc502f53147e3f6b2a86976a3571f3cc47d"
  name: "Fintoch (study family bec1df86), 1 of 3,980 addresses running it"
  upgradeable: "no"
families:
- code: "0x37d62fc502f53147e3f6b2a86976a3571f3cc47d"
  name: "Fintoch (study family bec1df86)"
  instances: 3980
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families bec1df86"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 3,980 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x37d62fc502f53147e3f6b2a86976a3571f3cc47d` (Fintoch, family `bec1df86`, 3,980 addresses, $0): Fintoch (Ownbit clone): distinct owners by ECDSA; owners fixed / Fintoch (Ownbit clone), any-call variant. Decided by: read (function text).
