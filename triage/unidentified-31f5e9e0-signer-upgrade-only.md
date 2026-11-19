---
id: unidentified-31f5e9e0-signer-upgrade-only
title: "46 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-31f5e9e0
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x331312dabaf3d69138c047aac278c9f9e0e8fff8"
  name: "unverified code (study family 5f091e6e), 1 of 46 addresses running it"
  upgradeable: "yes"
families:
- code: "0x331312dabaf3d69138c047aac278c9f9e0e8fff8"
  name: "unverified code (study family 5f091e6e)"
  instances: 46
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 6136
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 5f091e6e"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 46 addresses, $6k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x331312dabaf3d69138c047aac278c9f9e0e8fff8` (unverified, family `5f091e6e`, 46 addresses, $6k): 46 proxies: a constant and a stored key behind an upgradeable implementation. Decided by: bytecode and names (no source).
