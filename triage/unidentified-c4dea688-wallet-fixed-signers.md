---
id: unidentified-c4dea688-wallet-fixed-signers
title: "QredoWalletImplementation (5,562 copies): under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-c4dea688
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x1c6c390a6625f66a512f22ccad0d6ffcfdd01247"
  name: "QredoWalletImplementation (study family f00feccd), 1 of 5,562 addresses running it"
  upgradeable: "no"
families:
- code: "0x1c6c390a6625f66a512f22ccad0d6ffcfdd01247"
  name: "QredoWalletImplementation (study family f00feccd)"
  instances: 5562
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 11188
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f00feccd"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 5,562 addresses, $11k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x1c6c390a6625f66a512f22ccad0d6ffcfdd01247` (QredoWalletImplementation, family `f00feccd`, 5,562 addresses, $11k): Qredo wallet onlySigner: every call must be signed by _walletOwner; no function among its names changes the owner or lets it call directly. Decided by: read (function text).
