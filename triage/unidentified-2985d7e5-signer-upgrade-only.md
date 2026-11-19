---
id: unidentified-2985d7e5-signer-upgrade-only
title: "3 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-2985d7e5
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4cecb7f987d220fe2e8608149fa76ed6d021ad11"
  name: "unverified code (study family 498b59b6), 1 of 3 addresses running it"
  upgradeable: "yes"
families:
- code: "0x4cecb7f987d220fe2e8608149fa76ed6d021ad11"
  name: "unverified code (study family 498b59b6)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 498b59b6"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 3 addresses, $180 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x4cecb7f987d220fe2e8608149fa76ed6d021ad11` (unverified, family `498b59b6`, 3 addresses, $180): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Decided by: rule.
