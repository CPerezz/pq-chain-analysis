---
id: hexlotto-b9b2c647-fixed-gas-recovery
title: "HexLotto: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: HIGH
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xb9b2c64757fdc01a66f528dfa8e4b31a15a0ae24"
  family: "130ace09f8603ff64620126e148263ad"
  name: "HexLotto"
  upgradeable: "no"
  rating: HIGH
  value_usd: 13
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody can"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-gas-recovery"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "HIGH: players' HEX pot has no exit besides a verified draw and no owner/admin sweep reaches it; no update path."
---

## Summary

HexLotto, a HEX-ticket lottery drawn by Oraclize randomDS. The proof check fails at 3,000 gas, so the players' HEX pot is never paid out.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode: 6000 6001 610bb8 f1, a constant 3,000 gas to 0x01
- owner functions only set ticket price/minimum pot/ownership (decompiled); no owner/admin sweep of the HEX pot
- HEX balanceOf = 56,700 HEX at 26438999, not included in value_usd $13 (ETH only); not used to set this rating

## Impact and exposure

- Value held at block 26,438,999: $13 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on-chain; the pot stays locked, no sweep function covers it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
