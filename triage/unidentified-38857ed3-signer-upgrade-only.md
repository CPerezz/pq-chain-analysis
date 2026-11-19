---
id: unidentified-38857ed3-signer-upgrade-only
title: "EthStonks: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-38857ed3
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xde3f362a8f2e89c72eece8dc7b1d7a0cf8cbdb0b"
  name: "EthStonks (study family 7920edf8)"
  upgradeable: "yes"
  value_usd: 2887
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 7920edf8"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 1 address, $3k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xde3f362a8f2e89c72eece8dc7b1d7a0cf8cbdb0b` (EthStonks, family `7920edf8`, 1 address, $3k): the recovered address must be the admin. Decided by: read (function text).
