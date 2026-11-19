---
id: unidentified-a107483c-wallet-fixed-signers
title: "WalletSimple (3 copies): under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-a107483c
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x0d5f8a079042d5071220498fa0f0d7fd2c5fffbe"
  name: "WalletSimple (study family b82d09f4), 1 of 3 addresses running it"
  upgradeable: "no"
families:
- code: "0x0d5f8a079042d5071220498fa0f0d7fd2c5fffbe"
  name: "WalletSimple (study family b82d09f4)"
  instances: 3
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 5053
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b82d09f4"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 3 addresses, $5k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x0d5f8a079042d5071220498fa0f0d7fd2c5fffbe` (WalletSimple, family `b82d09f4`, 3 addresses, $5k): BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017): returns the signer to verifyMultiSig. Decided by: read (function text).
