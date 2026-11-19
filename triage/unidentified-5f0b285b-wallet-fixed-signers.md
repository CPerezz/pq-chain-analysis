---
id: unidentified-5f0b285b-wallet-fixed-signers
title: "19 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-5f0b285b
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x8a996346c16619398c1f229c55c65aa7a84e77c8"
  name: "unverified code (study family d4fab19c), 1 of 19 addresses running it"
  upgradeable: "no"
families:
- code: "0x8a996346c16619398c1f229c55c65aa7a84e77c8"
  name: "unverified code (study family d4fab19c)"
  instances: 19
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 26347
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families d4fab19c"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 19 addresses, $26k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x8a996346c16619398c1f229c55c65aa7a84e77c8` (unverified, family `d4fab19c`, 19 addresses, $26k): two-of-N spend wallets (19, 15 ETH with tokens; Unchained-style "spendNonce"): owners fixed. Decided by: bytecode and names (no source).
