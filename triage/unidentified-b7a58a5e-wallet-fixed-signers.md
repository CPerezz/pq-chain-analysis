---
id: unidentified-b7a58a5e-wallet-fixed-signers
title: "10,012 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-b7a58a5e
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb59199fbca58f66a3abdf825282e6f2443209a82"
  name: "unverified code (study family 97f6532e), 1 of 10,012 addresses running it"
  upgradeable: "no"
families:
- code: "0xb59199fbca58f66a3abdf825282e6f2443209a82"
  name: "unverified code (study family 97f6532e)"
  instances: 10012
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 97f6532e"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 10,012 addresses, $0 held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xb59199fbca58f66a3abdf825282e6f2443209a82` (unverified, family `97f6532e`, 10,012 addresses, $0): wallets whose ERC-1271 accepts the owner's ECDSA signature; the owner also executes directly. Decided by: bytecode and names (no source).
