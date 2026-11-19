---
id: unidentified-e24bfa48-signer-upgrade-only
title: "SmartAccountV2 (1,515 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-e24bfa48
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1609cca90126a4f51b4800418ba5bbd81d4b9ac6"
  name: "SmartAccountV2 (study family 775f9f4e), 1 of 1,515 addresses running it"
  upgradeable: "yes"
families:
- code: "0x1609cca90126a4f51b4800418ba5bbd81d4b9ac6"
  name: "SmartAccountV2 (study family 775f9f4e)"
  instances: 1515
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 18046
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 775f9f4e"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 1,515 addresses, $18k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x1609cca90126a4f51b4800418ba5bbd81d4b9ac6` (SmartAccountV2, family `775f9f4e`, 1,515 addresses, $18k): the user operation must be signed by the stored owner / isValidSignature: the recovered address must be an owner. Decided by: read (function text).
