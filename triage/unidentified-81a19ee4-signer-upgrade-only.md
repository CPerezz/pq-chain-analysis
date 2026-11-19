---
id: unidentified-81a19ee4-signer-upgrade-only
title: "2 contract families (5 addresses): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-81a19ee4
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf393d008077c97f2632fa04a910969ac58f88e3c"
  name: "unverified code (study family 0f9d9323), 1 of 2 addresses running it"
  upgradeable: "yes"
- address: "0xaa350d6f83e90275bffd528cb18310880ae170d9"
  name: "WithdrawAndDepositErc20 (study family 27a55a39), 1 of 3 addresses running it"
  upgradeable: "yes"
families:
- code: "0xf393d008077c97f2632fa04a910969ac58f88e3c"
  name: "unverified code (study family 0f9d9323)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 241811
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xaa350d6f83e90275bffd528cb18310880ae170d9"
  name: "WithdrawAndDepositErc20 (study family 27a55a39)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
  value_usd: 10647
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 0f9d9323, 27a55a39"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 2 code families, 5 addresses, $252k held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0xf393d008077c97f2632fa04a910969ac58f88e3c` (unverified, family `0f9d9323`, 2 addresses, $242k): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo). Decided by: rule. Executed: a real transaction reverts when its signer has code.
- `0xaa350d6f83e90275bffd528cb18310880ae170d9` (WithdrawAndDepositErc20, family `27a55a39`, 3 addresses, $11k): each signature must come from the oracle at its position in the stored list; a bitmask counts them. Decided by: read (function text).
