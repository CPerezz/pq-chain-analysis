---
id: eip-8151-signed-4337-gas-limits
title: "ERC-4337 operations whose signed verification gas is too small for EIP-8151's price"
status: candidate
severity: LOW
patterns: [PQ-18]
contracts:
- address: "0x0000fa3e509d629516ae56dc6fdd31047300114d"
  project: unidentified-c4556ef6
  name: "SafeL2 (study family cbf21f99), 1 of 928 addresses running it"
  upgradeable: "yes"
- address: "0x000000000804ff442be7d200445362c46a008add"
  project: unidentified-4f0cf2a1
  name: "unverified code (study family f441c4cb), 1 of 3 addresses running it"
  upgradeable: "yes"
families:
- code: "0x0000fa3e509d629516ae56dc6fdd31047300114d"
  name: "SafeL2 (study family cbf21f99)"
  instances: 928
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 228818
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x000000000804ff442be7d200445362c46a008add"
  name: "unverified code (study family f441c4cb)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, 2 families of the reading list"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
reviews: []
---

## Summary

A real operation of each family below fails under EIP-8151 even with more transaction gas: the verification limit is signed into the operation, so users must sign again with a higher one. 2 families, 931 addresses, $229k held.

## Evidence

Each family's recovery sites were read, judged from bytecode or placed by a measured rule; 1 families were also replayed on real transactions.
