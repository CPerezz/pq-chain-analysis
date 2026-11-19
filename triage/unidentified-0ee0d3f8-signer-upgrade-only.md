---
id: unidentified-0ee0d3f8-signer-upgrade-only
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-0ee0d3f8
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc71d3638e2f14c115eb53163ae97ae76eae9d7f6"
  name: "unverified code (study family 78965b68), 1 of 2 addresses running it"
  upgradeable: "yes"
families:
- code: "0xc71d3638e2f14c115eb53163ae97ae76eae9d7f6"
  name: "unverified code (study family 78965b68)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 78965b68"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $2k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xc71d3638e2f14c115eb53163ae97ae76eae9d7f6` (unverified, family `78965b68`, 2 addresses, $2k): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (proxy). Decided by: rule.
