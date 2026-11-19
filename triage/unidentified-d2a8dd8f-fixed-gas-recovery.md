---
id: unidentified-d2a8dd8f-fixed-gas-recovery
title: "3 contract families (3 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-d2a8dd8f
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x59bd11f8a5a833f26723d044cbb501a40c9c5e43"
  name: "unverified code (study family 62c04793)"
  upgradeable: "unknown"
- address: "0xb1a71b3526a3494857c4ef873f7702a11e2e3265"
  name: "unverified code (study family c5aac38b)"
  upgradeable: "unknown"
- address: "0x7c5fcccd3c94faf14a3a9391a7c52b734ac9fbd2"
  name: "unverified code (study family dbf3d256)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 62c04793, c5aac38b, dbf3d256"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 3 code families, 3 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x59bd11f8a5a833f26723d044cbb501a40c9c5e43` (unverified, family `62c04793`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xb1a71b3526a3494857c4ef873f7702a11e2e3265` (unverified, family `c5aac38b`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x7c5fcccd3c94faf14a3a9391a7c52b734ac9fbd2` (unverified, family `dbf3d256`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
