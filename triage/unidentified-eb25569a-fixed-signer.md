---
id: unidentified-eb25569a-fixed-signer
title: "N2MERC721A (9,022 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-eb25569a
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x0eb7c84b565196cedfe8c20a7e9510916d58ca6e"
  name: "N2MERC721A (study family 83c3b923), 1 of 9,022 addresses running it"
  upgradeable: "no"
families:
- code: "0x0eb7c84b565196cedfe8c20a7e9510916d58ca6e"
  name: "N2MERC721A (study family 83c3b923)"
  instances: 9022
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 83c3b923"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 9,022 addresses, $361 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x0eb7c84b565196cedfe8c20a7e9510916d58ca6e` (N2MERC721A, family `83c3b923`, 9,022 addresses, $361): N2M removeProtocolFee: signed by N2M_SIGNER, fixed in the code / N2M mintWhitelist: signed by N2M_SIGNER or the owner. Decided by: read (function text).
