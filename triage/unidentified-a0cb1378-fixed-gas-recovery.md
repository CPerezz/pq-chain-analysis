---
id: unidentified-a0cb1378-fixed-gas-recovery
title: "6 contract families (6 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-a0cb1378
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x52d757cb8be2ebd32af051b26898bce28ec19f13"
  name: "Game (study family 6d26b79d)"
  upgradeable: "unknown"
- address: "0x7409a88f44ac96cfae981f444d377b025002906a"
  name: "Game (study family 1062d37c)"
  upgradeable: "unknown"
- address: "0xbc4ca4a374ca6a798eccd3de072aaeb142b55026"
  name: "unverified code (study family aaf11fd8)"
  upgradeable: "unknown"
- address: "0x2704979baf77722a1ed87f718d5535230b576682"
  name: "Game (study family 43defa82)"
  upgradeable: "unknown"
- address: "0x325a974773be98a4291f67547a292decc43b3a02"
  name: "unverified code (study family 86245e63)"
  upgradeable: "unknown"
- address: "0xfb30a5154b3d1cd024319d3092b3708443aee960"
  name: "unverified code (study family 1e12a88b)"
  upgradeable: "unknown"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 6d26b79d, 1062d37c, aaf11fd8, 43defa82, 86245e63, 1e12a88b"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 6 code families, 6 addresses, $0 held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0x52d757cb8be2ebd32af051b26898bce28ec19f13` (Game, family `6d26b79d`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x7409a88f44ac96cfae981f444d377b025002906a` (Game, family `1062d37c`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xbc4ca4a374ca6a798eccd3de072aaeb142b55026` (unverified, family `aaf11fd8`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x2704979baf77722a1ed87f718d5535230b576682` (Game, family `43defa82`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x325a974773be98a4291f67547a292decc43b3a02` (unverified, family `86245e63`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xfb30a5154b3d1cd024319d3092b3708443aee960` (unverified, family `1e12a88b`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
