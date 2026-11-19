---
id: unidentified-4337ccb3-signer-upgrade-only
title: "Unverified contract 0x4b6e1a…: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-4337ccb3
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4b6e1a8ce2e8009d994ab66c04574a8d6aaf02fc"
  name: "unverified code (study family 391885fa)"
  upgradeable: "yes"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 391885fa"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x4b6e1a8ce2e8009d994ab66c04574a8d6aaf02fc` (unverified, family `391885fa`, 1 address, $0): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Decided by: rule. Executed: a real transaction reverts when its signer has code.
