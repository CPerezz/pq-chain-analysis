---
id: unidentified-6c773cbe-wallet-fixed-signers
title: "RecoverySignerFactory: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-6c773cbe
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x353d28177bab012a569f51e2b737b82bf1c373bc"
  name: "RecoverySignerFactory (study family f408b4ab)"
  upgradeable: "no"
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f408b4ab"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 1 address, $0 held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x353d28177bab012a569f51e2b737b82bf1c373bc` (RecoverySignerFactory, family `f408b4ab`, 1 address, $0): recovery signers for smart wallets: each is bound to one guardian whose signature (ECDSA or ERC-1271) is needed for every change of owners (read). Decided by: read. Executed: a real transaction reverts when its signer has code.
