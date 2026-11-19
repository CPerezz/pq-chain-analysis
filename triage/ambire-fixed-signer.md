---
id: ambire-fixed-signer
title: "2 contract families (172,523 addresses): under EIP-8151 the signed functions stop once the fixed signer has code"
project: ambire
status: candidate
severity: MEDIUM
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x9701ae64b07b51050934c683d35265c53c60f481"
  name: "AmbireAccount7702 (study family f5967d8d), 1 of 172,118 addresses running it, 172,117 by 7702 delegation"
  upgradeable: "no"
- address: "0xfde6d7303868fd2046c15263c9268618092664d1"
  name: "AmbireAccount (study family 8ec52cac), 1 of 405 addresses running it"
  upgradeable: "no"
families:
- code: "0x9701ae64b07b51050934c683d35265c53c60f481"
  name: "AmbireAccount7702 (study family f5967d8d)"
  instances: 172118
  list: "every address running this code at block 26,438,999 (172,117 by 7702 delegation)"
  upgradeable: "no"
  value_usd: 3452845
  value_basis: held
  value_as_of: 2026-11-18
- code: "0xfde6d7303868fd2046c15263c9268618092664d1"
  name: "AmbireAccount (study family 8ec52cac)"
  instances: 405
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1135610
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f5967d8d, 8ec52cac"
  date: 2026-11-19
  verdict: reported
  rating: MEDIUM
related: []
reviews: []
---

## Summary

The contract accepts signatures only from a key fixed in the code; once that key's account has code, the signed functions stop. 2 code families, 172,523 addresses, $4.6M held. Rated by hand: the fixed key is Ambire's paymaster relayer; the accounts' own keys can be replaced.

## Evidence

- `0x9701ae64b07b51050934c683d35265c53c60f481` (AmbireAccount7702, family `f5967d8d`, 172,118 addresses, $3.5M): Ambire account (7702) execute: the signer must hold a privilege in the account (the account itself does); the signature library also takes a contract signer through ERC-1271 and a Schnorr mode through ecrecover / Ambire… Decided by: read (function text).
- `0xfde6d7303868fd2046c15263c9268618092664d1` (AmbireAccount, family `8ec52cac`, 405 addresses, $1.1M): Ambire account execute: the signer must hold a privilege in the account; the library also takes contract signers and a Schnorr mode / Ambire account ERC-1271 (variant): the recovered key must hold a privilege / Ambire… Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
