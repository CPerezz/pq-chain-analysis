---
id: unidentified-00de4b13-signature-rechecked
title: "649 unverified contracts with one code: under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-00de4b13
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xb596616aaecea6c4940a30ea6f40d8f50e7aedd6"
  name: "unverified code (study family f1c112df), 1 of 649 addresses running it"
  upgradeable: "no"
families:
- code: "0xb596616aaecea6c4940a30ea6f40d8f50e7aedd6"
  name: "unverified code (study family f1c112df)"
  instances: 649
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f1c112df"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 649 addresses, $0 held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0xb596616aaecea6c4940a30ea6f40d8f50e7aedd6` (unverified, family `f1c112df`, 649 addresses, $0): 649 subscription contracts: a payment authorisation signed once by the subscriber is executed again at each period. Decided by: bytecode and names (no source).
