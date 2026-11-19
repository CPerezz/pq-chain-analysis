---
id: unidentified-a678cad8-wallet-fixed-signers
title: "Wallet (2,417 copies): under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-a678cad8
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x6eb8a25e9f13f4a3309473d38a646879b7ed1802"
  name: "Wallet (study family cd492f08), 1 of 2,417 addresses running it"
  upgradeable: "no"
families:
- code: "0x6eb8a25e9f13f4a3309473d38a646879b7ed1802"
  name: "Wallet (study family cd492f08)"
  instances: 2417
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 34106
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families cd492f08"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 1 code family, 2,417 addresses, $34k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x6eb8a25e9f13f4a3309473d38a646879b7ed1802` (Wallet, family `cd492f08`, 2,417 addresses, $34k): an oracle proof: the signature must match the public key carried in the proof, which chains to a key fixed in the code / an oracle proof: the signature must match a public key from the proof chain / returns the… Decided by: read (function text).
