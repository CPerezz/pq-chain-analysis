---
id: unidentified-6efba8fb-signature-rechecked
title: "3 contract families (1,563 addresses): under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-6efba8fb
status: candidate
severity: HIGH
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0xb5c8cd625c03ea406199e8fc3abea33f313dae92"
  name: "unverified code (study family 9e04da31), 1 of 135 addresses running it"
  upgradeable: "yes"
- address: "0xb5895693eaa1fca3acfa3c763c1556dc87a40e17"
  name: "unverified code (study family f8ffa7e2), 1 of 825 addresses running it"
  upgradeable: "yes"
- address: "0xb62524e93300503384effaed3bd1e699ca326f9f"
  name: "unverified code (study family bc88e65a), 1 of 603 addresses running it"
  upgradeable: "yes"
families:
- code: "0xb5c8cd625c03ea406199e8fc3abea33f313dae92"
  name: "unverified code (study family 9e04da31)"
  instances: 135
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1263
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xb5895693eaa1fca3acfa3c763c1556dc87a40e17"
  name: "unverified code (study family f8ffa7e2)"
  instances: 825
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
- code: "0xb62524e93300503384effaed3bd1e699ca326f9f"
  name: "unverified code (study family bc88e65a)"
  instances: 603
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 9e04da31, f8ffa7e2, bc88e65a"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 3 code families, 1,563 addresses, $1k held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0xb5c8cd625c03ea406199e8fc3abea33f313dae92` (unverified, family `9e04da31`, 135 addresses, $1k): Robonomics robot liabilities (135): demand and offer are signed promises; a validator signs the result (as f36169d3). Decided by: bytecode and names (no source).
- `0xb5895693eaa1fca3acfa3c763c1556dc87a40e17` (unverified, family `f8ffa7e2`, 825 addresses, $0): Robonomics liabilities, later version (825); same verdict as 9e04da31. Decided by: bytecode and names (no source).
- `0xb62524e93300503384effaed3bd1e699ca326f9f` (unverified, family `bc88e65a`, 603 addresses, $0): Robonomics liabilities (603); same verdict. Decided by: bytecode and names (no source).
