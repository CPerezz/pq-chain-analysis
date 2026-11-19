---
id: unidentified-64ce6a44-fixed-signer
title: "TarazVerifier (6 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-64ce6a44
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd4fc210a8a530b8edad5d6671638b27ae7d0ff57"
  name: "TarazVerifier (study family 175db256), 1 of 6 addresses running it"
  upgradeable: "no"
families:
- code: "0xd4fc210a8a530b8edad5d6671638b27ae7d0ff57"
  name: "TarazVerifier (study family 175db256)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 175db256"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 6 addresses, $0 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xd4fc210a8a530b8edad5d6671638b27ae7d0ff57` (TarazVerifier, family `175db256`, 6 addresses, $0): TarazVerifier: one signature, whose signer must be tarazSigner, fixed in the code. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
