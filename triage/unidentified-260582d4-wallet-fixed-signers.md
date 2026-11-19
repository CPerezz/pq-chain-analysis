---
id: unidentified-260582d4-wallet-fixed-signers
title: "23 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-260582d4
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x7b62e197c7d2bdc45d4a7dc435ed4bbf0ca2c0f5"
  name: "unverified code (study family 94bd484f), 1 of 23 addresses running it"
  upgradeable: "no"
families:
- code: "0x7b62e197c7d2bdc45d4a7dc435ed4bbf0ca2c0f5"
  name: "unverified code (study family 94bd484f)"
  instances: 23
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 94bd484f"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 23 addresses, $2k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x7b62e197c7d2bdc45d4a7dc435ed4bbf0ca2c0f5` (unverified, family `94bd484f`, 23 addresses, $2k): 23 multisig wallets with ordered owner signatures and no way to change owners. Decided by: bytecode and names (no source).
