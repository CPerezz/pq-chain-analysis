---
id: unidentified-5c5c476d-own-signature-only-exit
title: "MerchantConsolidator (35 copies): under EIP-8151 a party whose account has code can no longer act on its funds"
project: unidentified-5c5c476d
status: candidate
severity: CRITICAL
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0xccad95719d3e26caf3b87dc73ea4a140a67c9510"
  name: "MerchantConsolidator (study family d54dd91d), 1 of 35 addresses running it, 32 by 7702 delegation"
  upgradeable: "no"
families:
- code: "0xccad95719d3e26caf3b87dc73ea4a140a67c9510"
  name: "MerchantConsolidator (study family d54dd91d)"
  instances: 35
  list: "every address running this code at block 26,438,999 (32 by 7702 delegation)"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families d54dd91d"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract lets a party act on its funds or rights only with its own ECDSA signature. 1 code family, 35 addresses, $0 held. To settle the rating: is a direct way out missing for every party.

## Evidence

- `0xccad95719d3e26caf3b87dc73ea4a140a67c9510` (MerchantConsolidator, family `d54dd91d`, 35 addresses, $0): the stored registrar signs every assignment; a change of the authorised recipient also needs a 65-byte ECDSA signature of the merchant (read): a merchant whose address has code cannot give it. Decided by: read. Executed: a real transaction reverts when its signer has code.
