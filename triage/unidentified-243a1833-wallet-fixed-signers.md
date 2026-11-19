---
id: unidentified-243a1833-wallet-fixed-signers
title: "MultiSigPool: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-243a1833
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xe95b3dc78c0881dea17a69bafc6cfeb8d891e9de"
  name: "MultiSigPool (study family 3185e14b)"
  upgradeable: "no"
  value_usd: 4331
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 3185e14b"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 1 address, $4k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xe95b3dc78c0881dea17a69bafc6cfeb8d891e9de` (MultiSigPool, family `3185e14b`, 1 address, $4k): MultiSigPool withdrawETH: each signature from the allowed signer it names; no function changes the signers / MultiSigPool withdrawErc20: as withdrawETH / MultiSigPool factTransferErc20: as withdrawETH. Decided by: read (function text).
