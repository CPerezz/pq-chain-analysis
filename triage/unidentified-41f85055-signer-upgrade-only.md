---
id: unidentified-41f85055-signer-upgrade-only
title: "7 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-41f85055
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2d0a8c8557e1dfbc16ea4733349928a49f5f74b6"
  name: "unverified code (study family baaae3b3), 1 of 7 addresses running it"
  upgradeable: "yes"
families:
- code: "0x2d0a8c8557e1dfbc16ea4733349928a49f5f74b6"
  name: "unverified code (study family baaae3b3)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3970
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families baaae3b3"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 7 addresses, $4k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x2d0a8c8557e1dfbc16ea4733349928a49f5f74b6` (unverified, family `baaae3b3`, 7 addresses, $4k): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Decided by: rule. Executed: a real transaction reverts when its signer has code, before any recovery returned nothing: the code changed…
