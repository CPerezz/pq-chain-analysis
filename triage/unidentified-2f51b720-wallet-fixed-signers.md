---
id: unidentified-2f51b720-wallet-fixed-signers
title: "WalletSimple: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-2f51b720
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x30b71d015f60e2f959743038ce0aaec9b4c1ea44"
  name: "WalletSimple (study family 55e4db93)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 55e4db93"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 1 address, $0 held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x30b71d015f60e2f959743038ce0aaec9b4c1ea44` (WalletSimple, family `55e4db93`, 1 address, $0): BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017): returns the signer to verifyMultiSig. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
