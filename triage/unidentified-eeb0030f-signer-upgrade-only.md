---
id: unidentified-eeb0030f-signer-upgrade-only
title: "2 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-eeb0030f
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x10fc9e6ed49e648bde6b6214f07d8e63e12349e8"
  name: "unverified code (study family 214cc1d8), 1 of 2 addresses running it"
  upgradeable: "yes"
families:
- code: "0x10fc9e6ed49e648bde6b6214f07d8e63e12349e8"
  name: "unverified code (study family 214cc1d8)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 214cc1d8"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x10fc9e6ed49e648bde6b6214f07d8e63e12349e8` (unverified, family `214cc1d8`, 2 addresses, $0): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Decided by: rule. Executed: a real transaction reverts when its signer has code.
