---
id: unidentified-99c426b2-wallet-fixed-signers
title: "50 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-99c426b2
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x26aedb99b40466bd5d79d8589898db5e05daa827"
  name: "unverified code (study family b1a23d14), 1 of 50 addresses running it"
  upgradeable: "no"
families:
- code: "0x26aedb99b40466bd5d79d8589898db5e05daa827"
  name: "unverified code (study family b1a23d14)"
  instances: 50
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3790
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families b1a23d14"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 50 addresses, $4k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x26aedb99b40466bd5d79d8589898db5e05daa827` (unverified, family `b1a23d14`, 50 addresses, $4k): 50 wallets in the BitGo pattern. Decided by: bytecode and names (no source).
