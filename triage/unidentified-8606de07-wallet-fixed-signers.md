---
id: unidentified-8606de07-wallet-fixed-signers
title: "398 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-8606de07
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xa0a64a15dfb974f0dceb0660b92f9f3a2a3dddef"
  name: "unverified code (study family d5abad91), 1 of 398 addresses running it"
  upgradeable: "no"
families:
- code: "0xa0a64a15dfb974f0dceb0660b92f9f3a2a3dddef"
  name: "unverified code (study family d5abad91)"
  instances: 398
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families d5abad91"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 398 addresses, $0 held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xa0a64a15dfb974f0dceb0660b92f9f3a2a3dddef` (unverified, family `d5abad91`, 398 addresses, $0): 398 wallets: owners in a mapping; seven selectors, none changes owners. Decided by: bytecode and names (no source).
