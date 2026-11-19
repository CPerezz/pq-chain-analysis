---
id: unidentified-924c7387-fixed-signer
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-924c7387
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x67cac8b75357e944d893d426d349f64013ddba76"
  name: "unverified code (study family 6ffdfcea), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x67cac8b75357e944d893d426d349f64013ddba76"
  name: "unverified code (study family 6ffdfcea)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 6ffdfcea"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $902 held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x67cac8b75357e944d893d426d349f64013ddba76` (unverified, family `6ffdfcea`, 2 addresses, $902): owners with a threshold; no function name that changes owners. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
