---
id: unidentified-ac6342a7-wallet-fixed-signers
title: "277 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-ac6342a7
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x7082e5368d269c553e1a0b29a605d22f99374acc"
  name: "unverified code (study family 3dc74227), 1 of 277 addresses running it"
  upgradeable: "no"
families:
- code: "0x7082e5368d269c553e1a0b29a605d22f99374acc"
  name: "unverified code (study family 3dc74227)"
  instances: 277
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 24181
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 3dc74227"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 277 addresses, $24k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x7082e5368d269c553e1a0b29a605d22f99374acc` (unverified, family `3dc74227`, 277 addresses, $24k): 277 wallets: owners in a mapping, duplicates rejected; seven selectors, none changes owners. Decided by: bytecode and names (no source).
