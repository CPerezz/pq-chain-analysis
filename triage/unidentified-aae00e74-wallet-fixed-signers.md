---
id: unidentified-aae00e74-wallet-fixed-signers
title: "204 unverified contracts with one code: under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-aae00e74
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x4bb27b1b8685c7a3a7916740b97135086ed888d1"
  name: "unverified code (study family 4f4d8eda), 1 of 204 addresses running it"
  upgradeable: "no"
families:
- code: "0x4bb27b1b8685c7a3a7916740b97135086ed888d1"
  name: "unverified code (study family 4f4d8eda)"
  instances: 204
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 31399
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 4f4d8eda"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 204 addresses, $31k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x4bb27b1b8685c7a3a7916740b97135086ed888d1` (unverified, family `4f4d8eda`, 204 addresses, $31k): 204 wallets in the BitGo pattern (isSigner, sendMultiSig); no function name that changes signers. Decided by: bytecode and names (no source).
