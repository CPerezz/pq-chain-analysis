---
id: unidentified-62798e0b-fixed-signer
title: "GroupDAO (2 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-62798e0b
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x472e4fdea72e4eb8131817440b728c0c40e2ba02"
  name: "GroupDAO (study family ab9599b8), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x472e4fdea72e4eb8131817440b728c0c40e2ba02"
  name: "GroupDAO (study family ab9599b8)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 7760
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families ab9599b8"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $8k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x472e4fdea72e4eb8131817440b728c0c40e2ba02` (GroupDAO, family `ab9599b8`, 2 addresses, $8k): GroupDAO claim: signed by cSigner, fixed in the code. Decided by: read (function text).
