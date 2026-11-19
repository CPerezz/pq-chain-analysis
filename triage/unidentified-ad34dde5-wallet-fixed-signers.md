---
id: unidentified-ad34dde5-wallet-fixed-signers
title: "WalletSimple: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-ad34dde5
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd2ddb846a0ee31eb1f7150bfc31d324a4c674c38"
  name: "WalletSimple (study family e703d71f)"
  upgradeable: "no"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families e703d71f"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 1 address, $541 held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xd2ddb846a0ee31eb1f7150bfc31d324a4c674c38` (WalletSimple, family `e703d71f`, 1 address, $541): BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017): returns the signer to verifyMultiSig. Decided by: read (function text).
