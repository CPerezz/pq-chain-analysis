---
id: tbtc-signature-rechecked
title: "DepositRedemption (4,306 copies): under EIP-8151 a signature others relied on fails once its signer has code"
project: tbtc
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xafdf5b603f07cf664e44f3896bb2f0047d330ba4"
  name: "DepositRedemption (study family ef83389f), 1 of 4,306 addresses running it"
  upgradeable: "no"
families:
- code: "0xafdf5b603f07cf664e44f3896bb2f0047d330ba4"
  name: "DepositRedemption (study family ef83389f)"
  instances: 4306
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 234593
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families ef83389f"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 4,306 addresses, $235k held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0xafdf5b603f07cf664e44f3896bb2f0047d330ba4` (DepositRedemption, family `ef83389f`, 4,306 addresses, $235k): tBTC v1 CheckBitcoinSigs: the recovered address must be the address of the signing group's public key; used for the redemption signature and as proof of a fraudulent signature. Decided by: read (function text).
