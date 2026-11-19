---
id: unidentified-30f90304-wallet-fixed-signers
title: "WalletSimple (72 copies): under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-30f90304
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x3fbe1f8fc5ddb27d428aa60f661eaaab0d2000ce"
  name: "WalletSimple (study family 4a5db10c), 1 of 72 addresses running it"
  upgradeable: "no"
families:
- code: "0x3fbe1f8fc5ddb27d428aa60f661eaaab0d2000ce"
  name: "WalletSimple (study family 4a5db10c)"
  instances: 72
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 31941
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 4a5db10c"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 72 addresses, $32k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x3fbe1f8fc5ddb27d428aa60f661eaaab0d2000ce` (WalletSimple, family `4a5db10c`, 72 addresses, $32k): BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017): returns the signer to verifyMultiSig. Decided by: read (function text).
