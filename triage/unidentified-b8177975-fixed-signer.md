---
id: unidentified-b8177975-fixed-signer
title: "4 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-b8177975
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x46a954abda43baa4628cd12b985505190091fc8e"
  name: "unverified code (study family c4f3305d), 1 of 4 addresses running it"
  upgradeable: "no"
families:
- code: "0x46a954abda43baa4628cd12b985505190091fc8e"
  name: "unverified code (study family c4f3305d)"
  instances: 4
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c4f3305d"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 4 addresses, $2k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x46a954abda43baa4628cd12b985505190091fc8e` (unverified, family `c4f3305d`, 4 addresses, $2k): claims checked against one stored signer; all 66 selectors named and none replaces it. Decided by: bytecode and names (no source).
