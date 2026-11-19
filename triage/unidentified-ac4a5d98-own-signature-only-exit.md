---
id: unidentified-ac4a5d98-own-signature-only-exit
title: "CentWallet: under EIP-8151 a party whose account has code can no longer act on its funds"
project: unidentified-ac4a5d98
status: candidate
severity: CRITICAL
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0x2b78a837c37549539c62ab54a235a8e19fea812f"
  name: "CentWallet (study family 15670480)"
  upgradeable: "no"
  value_usd: 70017
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 15670480"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract lets a party act on its funds or rights only with its own ECDSA signature. 1 code family, 1 address, $70k held. To settle the rating: is a direct way out missing for every party.

## Evidence

- `0x2b78a837c37549539c62ab54a235a8e19fea812f` (CentWallet, family `15670480`, 1 address, $70k): CentWallet: every function is for the admin only and takes the signature of a key linked to the wallet; a wallet whose linked keys all sit on accounts with code cannot withdraw. 39 ETH, no recovery in the window. Decided by: read.
