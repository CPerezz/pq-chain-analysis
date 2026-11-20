---
id: a8a22f42-fixed-gas-recovery
title: "0xa8a22f42: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0xa8a22f42274bdd66b65abc8510fd808176f80cca"
  family: "925f75d56696561cb441d1870bd9faaf"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "FsTK-integrated contracts (setFsTKAuthority)"
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
  rating: MEDIUM
  note: "Holds nothing; a function stops, so MEDIUM."
---

## Summary

An FsTK authority variant: 0xc3662528 recovers a signer and returns its permission bits from storage_map_a. With 3,000 gas the recovery fails and signed authorizations are no longer recognized.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0x53e-0x543: PUSH1 0x01 PUSH2 0x0bb8 STATICCALL
- decompile 0xc3662528: returns storage_map_a[recovered] permission bits; 0xe3b252d8 lets an authorized msg.sender set permissions
- balance 0 at 26438999; family value $0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new authority and repoint the dependent contracts.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
