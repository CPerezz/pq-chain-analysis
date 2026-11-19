---
id: unidentified-7fd8faf3-fixed-signer
title: "5 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-7fd8faf3
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xa0e0e05b18f961da7c8b5adb7cb8ac2c9fc791c5"
  name: "unverified code (study family 29352590), 1 of 5 addresses running it"
  upgradeable: "no"
families:
- code: "0xa0e0e05b18f961da7c8b5adb7cb8ac2c9fc791c5"
  name: "unverified code (study family 29352590)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 29352590"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 5 addresses, $2k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xa0e0e05b18f961da7c8b5adb7cb8ac2c9fc791c5` (unverified, family `29352590`, 5 addresses, $2k): a signed deployer (5 addresses, 1.3 ETH): the owner set at init signs deployments; no owner setter by name. Decided by: bytecode and names (no source).
