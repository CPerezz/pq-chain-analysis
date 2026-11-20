---
id: 1cea8969-fixed-gas-recovery
title: "0x1cea8969: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: LOW
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x1cea89693fe39cbe245a0060f82ebdf525e9ea66"
  family: "e30a58aa4c560195e933e87465b49a7d"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: none
  who_acts: "accounts approved by the FsTK authority"
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
  rating: LOW
  note: "LOW: a direct-call way out exists"
---

## Summary

FsTK smart wallet: the signature-based delegated transfer uses a 3000-gas call to 0x01 and stops; direct transferEther/transferToken remain.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- facts note: 3000-gas call to 0x01 (no dossier; bytecode decompiled)
- decompiled: transferEther(0x05b1137b) and transferToken are gated only by the authority contract's check of msg.sender (staticcall 0x0a85bb25), no signature
- balance 0 ETH, value_usd null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Use the direct transferEther/transferToken calls.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
