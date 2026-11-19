---
id: unidentified-32708a7c-fixed-signer
title: "N2MERC721A (897 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-32708a7c
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc448f7d8745e6bc30bb2b54ffdc1b8f9534d2c6b"
  name: "N2MERC721A (study family 82ef4795), 1 of 897 addresses running it"
  upgradeable: "no"
families:
- code: "0xc448f7d8745e6bc30bb2b54ffdc1b8f9534d2c6b"
  name: "N2MERC721A (study family 82ef4795)"
  instances: 897
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 82ef4795"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 897 addresses, $180 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xc448f7d8745e6bc30bb2b54ffdc1b8f9534d2c6b` (N2MERC721A, family `82ef4795`, 897 addresses, $180): N2M removeProtocolFee: signed by N2M_SIGNER, fixed in the code / N2M mintWhitelist (variant): signed by the platform signer fixed in the code, or the owner. Decided by: read (function text).
