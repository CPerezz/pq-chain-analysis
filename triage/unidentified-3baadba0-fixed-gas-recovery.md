---
id: unidentified-3baadba0-fixed-gas-recovery
title: "4 contract families (4 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-3baadba0
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x663a5ca0295231b0d88afb1c557a8d8f4c1b6459"
  name: "Cillionaire (study family 58ded204)"
  upgradeable: "unknown"
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
- address: "0xdaff1f98299b12d475b4725a2635e5ba291aa651"
  name: "Cillionaire (study family 9824d44c)"
  upgradeable: "unknown"
- address: "0x02b97cca6d6a5227e464b2a60ee1a580ea4f7da9"
  name: "Cillionaire (study family 52b7d34c)"
  upgradeable: "unknown"
- address: "0xa1a465548fe36dcab13cd3150e45037460d425e8"
  name: "unverified code (study family f7392037)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 58ded204, 9824d44c, 52b7d34c, f7392037"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 4 code families, 4 addresses, $361 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x663a5ca0295231b0d88afb1c557a8d8f4c1b6459` (Cillionaire, family `58ded204`, 1 address, $361): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xdaff1f98299b12d475b4725a2635e5ba291aa651` (Cillionaire, family `9824d44c`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x02b97cca6d6a5227e464b2a60ee1a580ea4f7da9` (Cillionaire, family `52b7d34c`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xa1a465548fe36dcab13cd3150e45037460d425e8` (unverified, family `f7392037`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
