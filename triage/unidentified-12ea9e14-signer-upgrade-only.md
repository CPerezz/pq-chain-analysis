---
id: unidentified-12ea9e14-signer-upgrade-only
title: "23 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-12ea9e14
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x418349e3d6951dc37e4a10afe1b51394c9b8aafd"
  name: "unverified code (study family 9a621c98), 1 of 23 addresses running it"
  upgradeable: "yes"
families:
- code: "0x418349e3d6951dc37e4a10afe1b51394c9b8aafd"
  name: "unverified code (study family 9a621c98)"
  instances: 23
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 9a621c98"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 23 addresses, $361 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x418349e3d6951dc37e4a10afe1b51394c9b8aafd` (unverified, family `9a621c98`, 23 addresses, $361): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Decided by: rule. Executed: a real transaction reverts when its signer has code.
