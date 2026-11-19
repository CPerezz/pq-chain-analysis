---
id: unidentified-877cf5f0-own-signature-only-exit
title: "LocalCoinSwapEthereumEscrow: under EIP-8151 a party whose account has code can no longer act on its funds"
project: unidentified-877cf5f0
status: candidate
severity: CRITICAL
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0xda8b21b94668300ddbc0ecbaf57530d396287848"
  name: "LocalCoinSwapEthereumEscrow (study family 14aa34f4)"
  upgradeable: "no"
  value_usd: 2165
  value_basis: held
  value_as_of: 2026-11-18
families: []
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 14aa34f4"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract lets a party act on its funds or rights only with its own ECDSA signature. 1 code family, 1 address, $2k held. To settle the rating: is a direct way out missing for every party.

## Evidence

- `0xda8b21b94668300ddbc0ecbaf57530d396287848` (LocalCoinSwapEthereumEscrow, family `14aa34f4`, 1 address, $2k): LocalCoinSwap ETH escrow (variant): a dispute can be resolved only with a signature of the buyer or of the seller. Decided by: read.
