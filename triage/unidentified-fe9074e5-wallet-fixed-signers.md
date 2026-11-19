---
id: unidentified-fe9074e5-wallet-fixed-signers
title: "50 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-fe9074e5
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x1874c949e78174dd11e9881da35af86590cd7b32"
  name: "unverified code (study family aeecb6b6), 1 of 50 addresses running it"
  upgradeable: "no"
families:
- code: "0x1874c949e78174dd11e9881da35af86590cd7b32"
  name: "unverified code (study family aeecb6b6)"
  instances: 50
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 8301
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families aeecb6b6"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 50 addresses, $8k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x1874c949e78174dd11e9881da35af86590cd7b32` (unverified, family `aeecb6b6`, 50 addresses, $8k): 50 wallets in the BitGo pattern (isSigner, signers). Decided by: bytecode and names (no source).
