---
id: unidentified-6efba8fb-signature-rechecked-f36169
title: "Liability (9,388 copies): under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-6efba8fb
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xb58e7a24d017bbbe2b0233f9f6ca267770d55b46"
  name: "Liability (study family f36169d3), 1 of 9,388 addresses running it"
  upgradeable: "no"
families:
- code: "0xb58e7a24d017bbbe2b0233f9f6ca267770d55b46"
  name: "Liability (study family f36169d3)"
  instances: 9388
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f36169d3"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 9,388 addresses, $0 held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0xb58e7a24d017bbbe2b0233f9f6ca267770d55b46` (Liability, family `f36169d3`, 9,388 addresses, $0): Robonomics liability demand: the promisee named must have signed / Robonomics liability offer: the promisor named must have signed / Robonomics liability finalize: the result must be signed by the promisor, or by a… Decided by: read (function text).
