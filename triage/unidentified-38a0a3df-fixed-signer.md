---
id: unidentified-38a0a3df-fixed-signer
title: "LiteSig (3,947 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-38a0a3df
status: candidate
severity: MEDIUM
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x4bc3c92673d06688c865248c6696ea7c52d1710e"
  name: "LiteSig (study family c0b0a442), 1 of 3,947 addresses running it"
  upgradeable: "yes"
families:
- code: "0x4bc3c92673d06688c865248c6696ea7c52d1710e"
  name: "LiteSig (study family c0b0a442)"
  instances: 3947
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 84092
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c0b0a442"
  date: 2026-11-19
  verdict: reported
  rating: MEDIUM
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 3,947 addresses, $84k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x4bc3c92673d06688c865248c6696ea7c52d1710e` (LiteSig, family `c0b0a442`, 3,947 addresses, $84k): LiteSig: the required number of owners must sign in ascending order; owners are set at initialisation and no function changes them (submit read). Decided by: read.
