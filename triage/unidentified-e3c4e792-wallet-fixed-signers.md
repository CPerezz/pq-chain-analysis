---
id: unidentified-e3c4e792-wallet-fixed-signers
title: "163 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-e3c4e792
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xf738a52a5835caa35351996d45046354271c0eb6"
  name: "unverified code (study family df387e14), 1 of 163 addresses running it"
  upgradeable: "no"
families:
- code: "0xf738a52a5835caa35351996d45046354271c0eb6"
  name: "unverified code (study family df387e14)"
  instances: 163
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families df387e14"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 163 addresses, $180 held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xf738a52a5835caa35351996d45046354271c0eb6` (unverified, family `df387e14`, 163 addresses, $180): 163 wallets in the BitGo pattern. Decided by: bytecode and names (no source).
