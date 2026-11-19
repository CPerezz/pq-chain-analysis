---
id: unidentified-e3c47647-fixed-signer
title: "YesNo (22 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-e3c47647
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc39d73fca64d4ffe2c78fb17e61b9c8489f7c5fb"
  name: "YesNo (study family 64e86b8e), 1 of 22 addresses running it"
  upgradeable: "no"
families:
- code: "0xc39d73fca64d4ffe2c78fb17e61b9c8489f7c5fb"
  name: "YesNo (study family 64e86b8e)"
  instances: 22
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 121988
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 64e86b8e"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 22 addresses, $122k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xc39d73fca64d4ffe2c78fb17e61b9c8489f7c5fb` (YesNo, family `64e86b8e`, 22 addresses, $122k): YesNo market resolve: the outcome must be signed by ethAddr, the oracle's address fixed when the market was made. Decided by: read (function text).
