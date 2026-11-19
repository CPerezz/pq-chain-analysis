---
id: unidentified-08920622-wallet-fixed-signers
title: "159 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-08920622
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb68451e3bd326eef96a672cba83e9a7ebab76ead"
  name: "unverified code (study family 6e625a93), 1 of 159 addresses running it"
  upgradeable: "no"
families:
- code: "0xb68451e3bd326eef96a672cba83e9a7ebab76ead"
  name: "unverified code (study family 6e625a93)"
  instances: 159
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 6e625a93"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 159 addresses, $0 held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xb68451e3bd326eef96a672cba83e9a7ebab76ead` (unverified, family `6e625a93`, 159 addresses, $0): 159 wallet clones: one stored key; nine selectors, none replaces it. Decided by: bytecode and names (no source).
