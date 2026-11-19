---
id: unidentified-0dc6d3f0-signature-rechecked
title: "2 unverified contracts with one code: under EIP-8151 a signature others relied on fails once its signer has code"
project: unidentified-0dc6d3f0
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x11d0b2243739656f54c0277ed0eecde46658a537"
  name: "unverified code (study family baa73883), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x11d0b2243739656f54c0277ed0eecde46658a537"
  name: "unverified code (study family baa73883)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 7579
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families baa73883"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract checks a signature again after others relied on it; it fails once the signer's account has code. 1 code family, 2 addresses, $8k held. To settle the rating: who loses, how much is at stake, is the path still used.

## Evidence

- `0x11d0b2243739656f54c0277ed0eecde46658a537` (unverified, family `baa73883`, 2 addresses, $8k): a payment channel (4 ETH): tickets the provider signed are settled later; a provider with code would void unsettled tickets. Decided by: bytecode and names (no source).
