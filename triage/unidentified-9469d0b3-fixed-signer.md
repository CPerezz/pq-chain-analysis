---
id: unidentified-9469d0b3-fixed-signer
title: "7 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-9469d0b3
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae"
  name: "unverified code (study family 354598d4), 1 of 7 addresses running it"
  upgradeable: "no"
families:
- code: "0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae"
  name: "unverified code (study family 354598d4)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 354598d4"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 7 addresses, $3k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae` (unverified, family `354598d4`, 7 addresses, $3k): a pausable withdrawal contract (7 addresses, 1.5 ETH). Decided by: bytecode and names (no source).
