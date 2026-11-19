---
id: unidentified-52e979ca-fixed-signer
title: "PersonalBotVault (12 copies): under EIP-8151 the signed functions stop once the fixed signer has code"
project: unidentified-52e979ca
status: candidate
severity: CRITICAL
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xcfd1b66e7fde84ef41b5d9c56fe4b1e21e9d4b72"
  name: "PersonalBotVault (study family 13627ae6), 1 of 12 addresses running it"
  upgradeable: "no"
families:
- code: "0xcfd1b66e7fde84ef41b5d9c56fe4b1e21e9d4b72"
  name: "PersonalBotVault (study family 13627ae6)"
  instances: 12
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1805
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 13627ae6"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 1 code family, 12 addresses, $2k held. To settle the rating: is there a way out of the funds without that key.

## Evidence

- `0xcfd1b66e7fde84ef41b5d9c56fe4b1e21e9d4b72` (PersonalBotVault, family `13627ae6`, 12 addresses, $2k): PersonalBotVault: ERC-1271 accepts hashes signed by `signer`, set in the constructor with no setter (used for marketplace orders); the immutable owner withdraws directly. A signer with code ends the vault's signed… Decided by: read.
