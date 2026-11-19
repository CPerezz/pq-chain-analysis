---
id: localethereum-own-signature-only-exit
title: "2 contract families (4 addresses): under EIP-8151 a party whose account has code can no longer act on its funds"
project: localethereum
status: candidate
severity: CRITICAL
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0x867ffb5a3871b500f65bdfafe0136f9667deae06"
  name: "LocalEthereumEscrows (study family 583c5a37), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x09678741bd50c3e74301f38fbd0136307099ae5d"
  name: "LocalEthereumEscrows (study family afcdcf80), 1 of 2 addresses running it"
  upgradeable: "no"
families:
- code: "0x867ffb5a3871b500f65bdfafe0136f9667deae06"
  name: "LocalEthereumEscrows (study family 583c5a37)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 12091
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x09678741bd50c3e74301f38fbd0136307099ae5d"
  name: "LocalEthereumEscrows (study family afcdcf80)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 8842
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 583c5a37, afcdcf80"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract lets a party act on its funds or rights only with its own ECDSA signature. 2 code families, 4 addresses, $21k held. To settle the rating: is a direct way out missing for every party.

## Evidence

- `0x867ffb5a3871b500f65bdfafe0136f9667deae06` (LocalEthereumEscrows, family `583c5a37`, 2 addresses, $12k): LocalEthereum escrow: as LocalCoinSwap: a dispute can be resolved only with a signature of the buyer or of the seller. Decided by: read.
- `0x09678741bd50c3e74301f38fbd0136307099ae5d` (LocalEthereumEscrows, family `afcdcf80`, 2 addresses, $9k): LocalEthereum escrow v1: a dispute can be resolved only with a signature of the buyer or of the seller. Decided by: read.
