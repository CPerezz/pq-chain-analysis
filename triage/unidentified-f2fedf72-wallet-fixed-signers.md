---
id: unidentified-f2fedf72-wallet-fixed-signers
title: "8 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-f2fedf72
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xe2d86d998a497211648db0a18883e6b9d25d0400"
  name: "unverified code (study family 78aa418a), 1 of 8 addresses running it"
  upgradeable: "no"
families:
- code: "0xe2d86d998a497211648db0a18883e6b9d25d0400"
  name: "unverified code (study family 78aa418a)"
  instances: 8
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 289632
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 78aa418a"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 8 addresses, $290k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xe2d86d998a497211648db0a18883e6b9d25d0400` (unverified, family `78aa418a`, 8 addresses, $290k): multisig with ordered owner signatures and no function name that changes owners (161 ETH). Decided by: bytecode and names (no source).
