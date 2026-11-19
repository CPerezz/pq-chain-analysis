---
id: unidentified-46fd47e1-wallet-fixed-signers
title: "WalletSimple (144 copies): under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-46fd47e1
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xf09cb0c6f2be5a0f15101fd1e64e9b2bcc5e6470"
  name: "WalletSimple (study family ee1654f9), 1 of 144 addresses running it"
  upgradeable: "no"
families:
- code: "0xf09cb0c6f2be5a0f15101fd1e64e9b2bcc5e6470"
  name: "WalletSimple (study family ee1654f9)"
  instances: 144
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 40964
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families ee1654f9"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 144 addresses, $41k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xf09cb0c6f2be5a0f15101fd1e64e9b2bcc5e6470` (WalletSimple, family `ee1654f9`, 144 addresses, $41k): BitGo WalletSimple (variant): the second signer must be one of the wallet's fixed signers and not the caller / BitGo WalletSimple (0.8): returns the signer to verifyMultiSig; read in full for the registry entry. Decided by: read (function text).
