---
id: unidentified-fc0ae1db-wallet-fixed-signers
title: "WalletSimple (2 copies): under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-fc0ae1db
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xa0cccb2b4e2b8e6377502add514c6f3be4f21776"
  name: "WalletSimple (study family 3a6666e3), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0xa0cccb2b4e2b8e6377502add514c6f3be4f21776"
  name: "WalletSimple (study family 3a6666e3)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 3a6666e3"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 2 addresses, $0 held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xa0cccb2b4e2b8e6377502add514c6f3be4f21776` (WalletSimple, family `3a6666e3`, 2 addresses, $0): BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017): returns the signer to verifyMultiSig. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
