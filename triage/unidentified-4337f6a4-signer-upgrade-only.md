---
id: unidentified-4337f6a4-signer-upgrade-only
title: "Unverified contract 0x2ac7f0…: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-4337f6a4
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2ac7f0734b119d3b192cf1fb9c7db53c7af80202"
  name: "unverified code (study family af6926da)"
  upgradeable: "yes"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families af6926da"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x2ac7f0734b119d3b192cf1fb9c7db53c7af80202` (unverified, family `af6926da`, 1 address, $0): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Decided by: rule. Executed: a real transaction reverts when its signer has code.
