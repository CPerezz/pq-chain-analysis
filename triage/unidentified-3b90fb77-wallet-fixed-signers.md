---
id: unidentified-3b90fb77-wallet-fixed-signers
title: "40 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-3b90fb77
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xcc6fcfb8b3988043e382a481d6bf482d68897024"
  name: "unverified code (study family f1d85033), 1 of 40 addresses running it"
  upgradeable: "no"
families:
- code: "0xcc6fcfb8b3988043e382a481d6bf482d68897024"
  name: "unverified code (study family f1d85033)"
  instances: 40
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f1d85033"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 40 addresses, $2k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xcc6fcfb8b3988043e382a481d6bf482d68897024` (unverified, family `f1d85033`, 40 addresses, $2k): 40 multisig wallets with ordered owner signatures and no way to change owners. Decided by: bytecode and names (no source).
