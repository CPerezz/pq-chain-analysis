---
id: unidentified-a964d6e8-fixed-signer
title: "Pair (69 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-a964d6e8
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x5c47c9ab05716d26d6e339eb19d2be3a0b0b097e"
  name: "Pair (study family 029dd84e), 1 of 69 addresses running it"
  upgradeable: "no"
families:
- code: "0x5c47c9ab05716d26d6e339eb19d2be3a0b0b097e"
  name: "Pair (study family 029dd84e)"
  instances: 69
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 22918
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 029dd84e"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 69 addresses, $23k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x5c47c9ab05716d26d6e339eb19d2be3a0b0b097e` (Pair, family `029dd84e`, 69 addresses, $23k): Caviar pair: the price message must be signed by the Reservoir oracle address (text cut; fixed in the oracle contract by design) / solmate permit: the recovered address must be the owner named in the call, zero… Decided by: read (function text).
