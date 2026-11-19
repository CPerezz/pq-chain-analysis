---
id: archetype-signer-upgrade-only
title: "ArchetypeLogic (5 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: archetype
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x750ee3529d13819e00e4e67063d6e500870d5af3"
  name: "ArchetypeLogic (study family 16b829f0), 1 of 5 addresses running it"
  upgradeable: "yes"
families:
- code: "0x750ee3529d13819e00e4e67063d6e500870d5af3"
  name: "ArchetypeLogic (study family 16b829f0)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 4511
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 16b829f0"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 5 addresses, $5k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x750ee3529d13819e00e4e67063d6e500870d5af3` (ArchetypeLogic, family `16b829f0`, 5 addresses, $5k): Archetype affiliate check: the signer must be the affiliate signer of the collection's configuration. Decided by: read (function text).
