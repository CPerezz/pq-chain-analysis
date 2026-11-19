---
id: unidentified-75cad9d7-wallet-fixed-signers
title: "2 contract families (26 addresses): under EIP-8151 wallets lock once their fixed signers take code"
project: unidentified-75cad9d7
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x137dcd97872de27a4d3bf36a4643c5e18fa40713"
  name: "SimpleMultiSig (study family f9810ce4), 1 of 21 addresses running it"
  upgradeable: "no"
- address: "0x41673ae53a2ffb749e9769048a36fa23ce28cf89"
  name: "SimpleMultiSig (study family cad01166), 1 of 5 addresses running it"
  upgradeable: "no"
families:
- code: "0x137dcd97872de27a4d3bf36a4643c5e18fa40713"
  name: "SimpleMultiSig (study family f9810ce4)"
  instances: 21
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 4872
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x41673ae53a2ffb749e9769048a36fa23ce28cf89"
  name: "SimpleMultiSig (study family cad01166)"
  instances: 5
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 3609
  value_basis: held
  value_as_of: 2026-11-18
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families f9810ce4, cad01166"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: []
reviews: []
---

## Summary

The contract is a wallet whose signers are fixed in the code; once enough of them take code, nothing moves. 2 code families, 26 addresses, $8k held. To settle the rating: how many signers must take code before the wallet locks.

## Evidence

- `0x137dcd97872de27a4d3bf36a4643c5e18fa40713` (SimpleMultiSig, family `f9810ce4`, 21 addresses, $5k): SimpleMultiSig (original): `threshold` owners in ascending order by ECDSA; no function changes the owners. Decided by: read (function text).
- `0x41673ae53a2ffb749e9769048a36fa23ce28cf89` (SimpleMultiSig, family `cad01166`, 5 addresses, $4k): SimpleMultiSig (0.6 variant): owners fixed. Decided by: read (function text).
