---
id: unidentified-df576863-signer-upgrade-only
title: "PaymentPlanV2Logic (5 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-df576863
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe803684b9e391d01dc1cdf76bac9ae3a596b2ae0"
  name: "PaymentPlanV2Logic (study family fc7c0b12), 1 of 5 addresses running it"
  upgradeable: "yes"
families:
- code: "0xe803684b9e391d01dc1cdf76bac9ae3a596b2ae0"
  name: "PaymentPlanV2Logic (study family fc7c0b12)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 3790
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families fc7c0b12"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 5 addresses, $4k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xe803684b9e391d01dc1cdf76bac9ae3a596b2ae0` (PaymentPlanV2Logic, family `fc7c0b12`, 5 addresses, $4k): Cyan payment plan: signed by the signer its caller passes, the platform's / Cyan plan revival: signed by the platform signer / Cyan early unwind (OpenSea): signed by the platform signer / Cyan early unwind: signed by… Decided by: read (function text).
