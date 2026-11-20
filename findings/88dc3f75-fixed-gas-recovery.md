---
id: 88dc3f75-fixed-gas-recovery
title: "0x88dc3f75: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: LOW
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x88dc3f7554ef092ea5c750cec7dfd31d732a2794"
  family: "fe3c33795d17df3bd44e20ca5a7de21a"
  copies: 2
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owners of the contracts that use this authority"
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
  note: "An authority contract: only authorisation by signature stops here, and the contracts that use it can point to another authority (a setting), so LOW."
---

## Summary

An FsTK authority contract: 0xc3662528(hash, ts, sig) recovers a signer and checks it against an authorized list, which other FsTK contracts use to validate actions. With 3,000 gas, signature validation always fails.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0x77e-0x783: PUSH1 0x01 PUSH2 0x0bb8 STATICCALL
- decompile 0xc3662528: the ecrecover result is used for authorization; canCall(address,address,bytes4) and 0x0a85bb25 are the admin checks
- balance 0 at 26438999; family value $0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new authority and point dependent contracts to it with setFsTKAuthority.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
