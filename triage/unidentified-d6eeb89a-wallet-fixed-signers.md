---
id: unidentified-d6eeb89a-wallet-fixed-signers
title: "IvtMultiSigWallet (68 copies): under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-d6eeb89a
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xa88d3efc0661aebb9c7b67dc88633f945ea96dfb"
  name: "IvtMultiSigWallet (study family bd290a2a), 1 of 68 addresses running it"
  upgradeable: "no"
families:
- code: "0xa88d3efc0661aebb9c7b67dc88633f945ea96dfb"
  name: "IvtMultiSigWallet (study family bd290a2a)"
  instances: 68
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families bd290a2a"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 68 addresses, $2k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xa88d3efc0661aebb9c7b67dc88633f945ea96dfb` (IvtMultiSigWallet, family `bd290a2a`, 68 addresses, $2k): IvtMultiSigWallet: signers are set in the constructor. Decided by: read.
