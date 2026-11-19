---
id: unidentified-a1be220e-signer-upgrade-only
title: "EthereumAlphaGrowthMultiFeedAdapterWithoutRoundsV2 (2 copies): under EIP-8151 the signed functions stop until an upgrade replaces the signer"
project: unidentified-a1be220e
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5232974bcd5a3ffe41478736bb8b0e760130c800"
  name: "EthereumAlphaGrowthMultiFeedAdapterWithoutRoundsV2 (study family d072ae45), 1 of 2 addresses running it"
  upgradeable: "yes"
families:
- code: "0x5232974bcd5a3ffe41478736bb8b0e760130c800"
  name: "EthereumAlphaGrowthMultiFeedAdapterWithoutRoundsV2 (study family d072ae45)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "yes"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families d072ae45"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop. 1 code family, 2 addresses, $0 held. To settle the rating: are funds stuck or does a function stop; who holds the upgrade.

## Evidence

- `0x5232974bcd5a3ffe41478736bb8b0e760130c800` (EthereumAlphaGrowthMultiFeedAdapterWithoutRoundsV2, family `d072ae45`, 2 addresses, $0): RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed. Decided by: read (function text). Executed: a real transaction reverts when its signer has code.
