---
id: unidentified-18559fec-fixed-gas-recovery
title: "5 contract families (13 addresses): under EIP-8151 every valid signature fails on activation day"
project: unidentified-18559fec
status: candidate
severity: CRITICAL
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xbfb45549e5630e1f4e6bb4d3f7132563100e08c9"
  name: "LuckyStrike (study family 1ab8a524), 1 of 2 addresses running it"
  upgradeable: "no"
- address: "0x41b02ee4209e74d543a6df85938ec628cde380e3"
  name: "LuckyStrike (study family 2827ac7b), 1 of 7 addresses running it"
  upgradeable: "unknown"
- address: "0x5f2c33230c668325374f36fdc520e8c23bc75ef5"
  name: "unverified code (study family f35f7b70), 1 of 2 addresses running it"
  upgradeable: "unknown"
- address: "0x433c32ee665c932986710e6dc028b6fb3b2fd126"
  name: "LuckyStrike (study family 8f946a62)"
  upgradeable: "unknown"
- address: "0xe4dff030976cb5e8606e4138a1cd57b4131f9e8b"
  name: "LuckyStrike (study family 31d2bf46)"
  upgradeable: "unknown"
families:
- code: "0xbfb45549e5630e1f4e6bb4d3f7132563100e08c9"
  name: "LuckyStrike (study family 1ab8a524)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "no"
  value_usd: 1985
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x41b02ee4209e74d543a6df85938ec628cde380e3"
  name: "LuckyStrike (study family 2827ac7b)"
  instances: 7
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x5f2c33230c668325374f36fdc520e8c23bc75ef5"
  name: "unverified code (study family f35f7b70)"
  instances: 2
  list: "every address running this code at block 26,438,999"
  upgradeable: "unknown"
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 1ab8a524, 2827ac7b, f35f7b70, 8f946a62, 31d2bf46"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

The contract gives `ecrecover` a fixed amount of gas below EIP-8151's price, so every valid signature fails from activation day. 5 code families, 13 addresses, $2k held. To settle the rating: does the failing check guard the only way out of funds others own.

## Evidence

- `0xbfb45549e5630e1f4e6bb4d3f7132563100e08c9` (LuckyStrike, family `1ab8a524`, 2 addresses, $2k): Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a constant 3,000 gas to the precompile;… Decided by: read (function text).
- `0x41b02ee4209e74d543a6df85938ec628cde380e3` (LuckyStrike, family `2827ac7b`, 7 addresses, $180): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x5f2c33230c668325374f36fdc520e8c23bc75ef5` (unverified, family `f35f7b70`, 2 addresses, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0x433c32ee665c932986710e6dc028b6fb3b2fd126` (LuckyStrike, family `8f946a62`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
- `0xe4dff030976cb5e8606e4138a1cd57b4131f9e8b` (LuckyStrike, family `31d2bf46`, 1 address, $0): 3000 gas to the precompile: every valid signature fails. Decided by: scanner facts.
