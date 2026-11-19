---
id: unidentified-759c5f29-signer-upgrade-only
title: "Traitz (2 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-759c5f29
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdc7411d597111c83d7bcbc7c7523e9b2cd22c9eb"
  name: "Traitz (study family 2a0e9894), 1 of 2 addresses running it"
  upgradeable: "yes"
families:
- code: "0xdc7411d597111c83d7bcbc7c7523e9b2cd22c9eb"
  name: "Traitz (study family 2a0e9894)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 14978
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 2a0e9894"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $15k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xdc7411d597111c83d7bcbc7c7523e9b2cd22c9eb` (Traitz, family `2a0e9894`, 2 addresses, $15k): the recovered address must be the stored signerAlt. Decided by: read (function text).
