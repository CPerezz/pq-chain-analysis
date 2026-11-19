---
id: unidentified-aaaaaace-fixed-signer
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-aaaaaace
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xaaaaaaceeed2b24ef8083f8703c6d6f3a36e1137"
  name: "unverified code (study family 9fa16c2f), 1 of 2 addresses running it, 1 by 7702 delegation"
  upgradeable: "no"
families:
- code: "0xaaaaaaceeed2b24ef8083f8703c6d6f3a36e1137"
  name: "unverified code (study family 9fa16c2f)"
  instances: 2
  list: "every address running this code at block 26,438,999 (1 by 7702 delegation)"
  upgradeable: "no"
  value_usd: 20031
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 9fa16c2f"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $20k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xaaaaaaceeed2b24ef8083f8703c6d6f3a36e1137` (unverified, family `9fa16c2f`, 2 addresses, $20k): a signer that is a constant in the code. Decided by: bytecode and names (no source).
