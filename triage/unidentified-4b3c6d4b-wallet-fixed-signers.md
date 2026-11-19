---
id: unidentified-4b3c6d4b-wallet-fixed-signers
title: "249 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-4b3c6d4b
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x576a89c793d1210ba9fdd4fe15f0e9a2e2bc5363"
  name: "unverified code (study family 1d086d30), 1 of 249 addresses running it"
  upgradeable: "no"
families:
- code: "0x576a89c793d1210ba9fdd4fe15f0e9a2e2bc5363"
  name: "unverified code (study family 1d086d30)"
  instances: 249
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 29595
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 1d086d30"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 249 addresses, $30k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x576a89c793d1210ba9fdd4fe15f0e9a2e2bc5363` (unverified, family `1d086d30`, 249 addresses, $30k): Henesis custody wallets (249, 16 ETH with tokens): the account and backup keys that sign are fixed; a key with code ends that wallet's signed operations, so funds must move before the keys migrate. Decided by: bytecode and names (no source).
