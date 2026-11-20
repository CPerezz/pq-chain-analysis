---
id: 5ee190e8-fixed-gas-recovery
title: "0x5ee190e8: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: HIGH
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x5ee190e83ed4f83182da958c10582d60849486af"
  family: "cb74eed3c5a8d79fc97559dd179a9eb0"
  copies: 1168
  upgradeable: "no"
  rating: HIGH
  value_usd: 9
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-10-01
fix:
  layer: none
  who_acts: "nobody can: owners' funds stay locked"
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
  note: "HIGH: owners' funds, every exit is signature-gated, no sweep function, no update path."
---

## Summary

Same 1,041-byte 2-signature multisig as 0xfd1e02 (1,168 copies in this family). Every transfer needs two ecrecovers via a STATICCALL with 3,072 gas, so funds lock at activation.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: every valid signature fails: the code gives the precompile 3,072 gas. Bytecode.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode: 6000 6001 610c00 fa, a STATICCALL to 0x01 with a constant 3,072 gas; code identical in layout to 0xfd1e02
- exits 0x9d55b53f / 0xf063042d both require two owner signatures; owner changes only via msg.sender == this
- balance 0.005 ETH; 1 tx in 90 days, last active 2026-10-01 (dormant/low-value does not lower this rating)

## Impact and exposure

- Value held at block 26,438,999: $9 (ETH and 49 priced tokens, over 1,168 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-01.

## Remediation

Owners must move funds out before activation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
