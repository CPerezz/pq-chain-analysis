---
id: unidentified-4337bd13-signer-upgrade-only
title: "Unverified contract 0xb1ab0a…: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-4337bd13
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb1ab0a457916344dfc3c2cf330d858c812c64172"
  name: "unverified code (study family 1026f12b)"
  upgradeable: "yes"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 1026f12b"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xb1ab0a457916344dfc3c2cf330d858c812c64172` (unverified, family `1026f12b`, 1 address, $0): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Decided by: rule. Executed: a real transaction reverts when its signer has code.
