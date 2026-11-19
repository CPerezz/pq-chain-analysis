---
id: unidentified-101dc51f-signer-upgrade-only
title: "19 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-101dc51f
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7244dbf4461daa2a51d1c2424bc296e0e60d8f5f"
  name: "unverified code (study family 001223f7), 1 of 19 addresses running it"
  upgradeable: "yes"
families:
- code: "0x7244dbf4461daa2a51d1c2424bc296e0e60d8f5f"
  name: "unverified code (study family 001223f7)"
  instances: 19
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 001223f7"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 19 addresses, $2k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x7244dbf4461daa2a51d1c2424bc296e0e60d8f5f` (unverified, family `001223f7`, 19 addresses, $2k): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (proxy). Decided by: rule.
