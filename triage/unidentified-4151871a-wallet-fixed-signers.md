---
id: unidentified-4151871a-wallet-fixed-signers
title: "247 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-4151871a
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb744b06f05dba47c211e50a9e3052a69f9db53f7"
  name: "unverified code (study family f6adb0e0), 1 of 247 addresses running it"
  upgradeable: "no"
families:
- code: "0xb744b06f05dba47c211e50a9e3052a69f9db53f7"
  name: "unverified code (study family f6adb0e0)"
  instances: 247
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f6adb0e0"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 247 addresses, $0 held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xb744b06f05dba47c211e50a9e3052a69f9db53f7` (unverified, family `f6adb0e0`, 247 addresses, $0): wallets whose ERC-1271 accepts the owner's ECDSA signature; the owner executes directly. Decided by: bytecode and names (no source).
