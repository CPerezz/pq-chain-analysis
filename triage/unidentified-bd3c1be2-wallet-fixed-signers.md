---
id: unidentified-bd3c1be2-wallet-fixed-signers
title: "SimpleMultiSig (3,210 copies): under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-bd3c1be2
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x3867a3c7d53547eae0a20050957ec37064bce15f"
  name: "SimpleMultiSig (study family 2cce101b), 1 of 3,210 addresses running it"
  upgradeable: "no"
families:
- code: "0x3867a3c7d53547eae0a20050957ec37064bce15f"
  name: "SimpleMultiSig (study family 2cce101b)"
  instances: 3210
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 2cce101b"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 3,210 addresses, $541 held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x3867a3c7d53547eae0a20050957ec37064bce15f` (SimpleMultiSig, family `2cce101b`, 3,210 addresses, $541): SimpleMultiSig (first version): owners fixed. Decided by: read (function text).
