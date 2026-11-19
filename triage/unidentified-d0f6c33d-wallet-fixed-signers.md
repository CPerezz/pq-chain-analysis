---
id: unidentified-d0f6c33d-wallet-fixed-signers
title: "5 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-d0f6c33d
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc8d9b8052b59c8f0f496b3c2e1403ca441192d73"
  name: "unverified code (study family b507d864), 1 of 5 addresses running it"
  upgradeable: "no"
families:
- code: "0xc8d9b8052b59c8f0f496b3c2e1403ca441192d73"
  name: "unverified code (study family b507d864)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b507d864"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 5 addresses, $0 held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xc8d9b8052b59c8f0f496b3c2e1403ca441192d73` (unverified, family `b507d864`, 5 addresses, $0): multisig with ordered owner signatures; no function name that changes owners. Decided by: bytecode and names (no source). Executed: a real transaction reverts when its signer has code.
