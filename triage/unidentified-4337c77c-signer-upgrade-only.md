---
id: unidentified-4337c77c-signer-upgrade-only
title: "5 unverified contracts with one code: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-4337c77c
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb6c0db1bd1b8d63b5aacf7d50eddee68311374c0"
  name: "unverified code (study family fe6f44b3), 1 of 5 addresses running it"
  upgradeable: "yes"
families:
- code: "0xb6c0db1bd1b8d63b5aacf7d50eddee68311374c0"
  name: "unverified code (study family fe6f44b3)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families fe6f44b3"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 5 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xb6c0db1bd1b8d63b5aacf7d50eddee68311374c0` (unverified, family `fe6f44b3`, 5 addresses, $0): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Decided by: rule. Executed: a real transaction reverts when its signer has code.
