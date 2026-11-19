---
id: teambrella-fixed-gas-recovery
title: "2 contract families (582 addresses): under EIP-8151 every valid signature fails on activation day"
project: teambrella
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xda3c13eaa3d19d27e25553a1fc67b751398b2840"
  name: "TeambrellaWallet (study family 1b2c3251), 1 of 400 addresses running it"
  upgradeable: "no"
- address: "0x4fe25c676fe5e0324a5ec7f5446af9c0a633d7a2"
  name: "TeambrellaWallet (study family 283a9857), 1 of 182 addresses running it"
  upgradeable: "no"
families:
- code: "0xda3c13eaa3d19d27e25553a1fc67b751398b2840"
  name: "TeambrellaWallet (study family 1b2c3251)"
  instances: 400
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 25625
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x4fe25c676fe5e0324a5ec7f5446af9c0a633d7a2"
  name: "TeambrellaWallet (study family 283a9857)"
  instances: 182
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 23640
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 1b2c3251, 283a9857"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 2 code families, 582 addresses, $49k held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xda3c13eaa3d19d27e25553a1fc67b751398b2840` (TeambrellaWallet, family `1b2c3251`, 400 addresses, $26k): Teambrella wallet (checkSignatures and changeAllCosigners read): one to three stored cosigners must sign each operation; the set is replaced by an operation that the current cosigners sign and the owner sends. Decided by: read.
- `0x4fe25c676fe5e0324a5ec7f5446af9c0a633d7a2` (TeambrellaWallet, family `283a9857`, 182 addresses, $24k): Teambrella wallet, older version: the same design as 1b2c3251; every recovery goes through safer_ecrecover with a constant 3,000 gas (read), below the new price. Decided by: read.
