---
id: aef17ac4-fixed-gas-recovery
title: "0xaef17ac4: fixed gas for ecrecover below EIP-8151's price"
status: not-affected
severity: NONE
patterns: [PQ-14]
impact: none
contracts:
- address: "0xaef17ac4ac6534a31a765095fc4cb00acfe5319a"
  family: "aaf6983ad5d1ef382c27098e0f386b48"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "Refuted: the call to 0x01 has no signature input and its result is never used."
---

## Summary

The 5,000-gas STATICCALL to 0x01 sends empty input and discards both the result and the return data; it recovers no signature (it reads as a precompile probe or an event filler). EIP-8151 changes nothing that this contract relies on.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 5000 gas to the precompile: fails when the recovered address is cold. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0xe31: PUSH0 DUP1 PUSH0 DUP1 PUSH1 0x01 PUSH2 0x1388 STATICCALL POP: args offset 0 and size 0, out size 0, success popped
- after the call: RETURNDATASIZE, TIMESTAMP and ADDRESS go into a LOG; no comparison with any signer
- functions: deposit, withdraw, withdrawAmount, owner() = 0xc25fce14…; balance 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
