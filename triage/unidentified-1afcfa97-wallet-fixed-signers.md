---
id: unidentified-1afcfa97-wallet-fixed-signers
title: "112 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-1afcfa97
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xa6e7219077d88d8a3f07e81f72aa76b2f031beef"
  name: "unverified code (study family 7036816f), 1 of 112 addresses running it"
  upgradeable: "no"
families:
- code: "0xa6e7219077d88d8a3f07e81f72aa76b2f031beef"
  name: "unverified code (study family 7036816f)"
  instances: 112
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 7036816f"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 112 addresses, $541 held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xa6e7219077d88d8a3f07e81f72aa76b2f031beef` (unverified, family `7036816f`, 112 addresses, $541): 112 wallets: owners in a mapping; six selectors, none changes owners. Decided by: bytecode and names (no source).
