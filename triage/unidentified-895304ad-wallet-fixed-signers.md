---
id: unidentified-895304ad-wallet-fixed-signers
title: "6 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-895304ad
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd9b20cfed69e76acae3fa1c2ee1faafafcb41f55"
  name: "unverified code (study family 45ff45a3), 1 of 6 addresses running it"
  upgradeable: "no"
families:
- code: "0xd9b20cfed69e76acae3fa1c2ee1faafafcb41f55"
  name: "unverified code (study family 45ff45a3)"
  instances: 6
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 27249
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 45ff45a3"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 6 addresses, $27k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0xd9b20cfed69e76acae3fa1c2ee1faafafcb41f55` (unverified, family `45ff45a3`, 6 addresses, $27k): four selectors: a multisig with ordered owner signatures and no way to change owners. Decided by: bytecode and names (no source).
