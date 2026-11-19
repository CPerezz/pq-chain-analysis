---
id: unidentified-3579e28f-signer-upgrade-only
title: "Unverified contract 0xd4161f…: under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-3579e28f
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd4161fb7aa24b2485c8328116db3165d63a5a3d3"
  name: "unverified code (study family 9a0a1455)"
  upgradeable: "yes"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 9a0a1455"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 1 address, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xd4161fb7aa24b2485c8328116db3165d63a5a3d3` (unverified, family `9a0a1455`, 1 address, $0): an upgradeable fund pool whose ERC-1271 accepts signatures of its admins (6 recoveries). Decided by: bytecode and names (no source). Executed: a real transaction does the same, with the same logs, when its signer has code.
