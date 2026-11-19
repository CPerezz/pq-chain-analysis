---
id: unidentified-4337eb57-signer-upgrade-only
title: "Unverified contract 0x3a535b…: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-4337eb57
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3a535bf46599b70baa1143c23f1cb2a07bc1ec46"
  name: "unverified code (study family 98043ace)"
  upgradeable: "yes"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 98043ace"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x3a535bf46599b70baa1143c23f1cb2a07bc1ec46` (unverified, family `98043ace`, 1 address, $0): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Decided by: rule. Executed: a real transaction reverts when its signer has code.
