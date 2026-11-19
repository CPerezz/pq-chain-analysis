---
id: unidentified-abfe329f-signer-upgrade-only
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-abfe329f
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbf4cfccd11257e568a936a7867d138f54a43cffa"
  name: "unverified code (study families cd637a1e, dfe2cd89), 1 of 2 addresses running it"
  upgradeable: "yes"
families:
- code: "0xbf4cfccd11257e568a936a7867d138f54a43cffa"
  name: "unverified code (study families cd637a1e, dfe2cd89)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 13354
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families cd637a1e"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $13k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xbf4cfccd11257e568a936a7867d138f54a43cffa` (unverified, family `cd637a1e`, 2 addresses, $13k): validators and guardians with thresholds behind an upgradeable proxy; no setter name seen. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
