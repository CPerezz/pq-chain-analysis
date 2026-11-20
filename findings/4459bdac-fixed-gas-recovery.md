---
id: 4459bdac-fixed-gas-recovery
title: "0x4459bdac: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x4459bdac55c2b9484d013802b4cae1724551d787"
  family: "fb1bdee2dec7b77dec5184e6ab23ff8f"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner 0xc25fce14… (EOA), via withdraw()/withdrawAmount()"
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
  note: "MEDIUM: the signed path dies for good (no update path), but the owner-sweep withdraw() gets the money out"
---

## Summary

Owner-run contract with a 5000-gas STATICCALL to 0x01: it fails whenever the recovered address is cold (6100 gas), the usual case, so the signed path dies for good.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 5000 gas to the precompile: fails when the recovered address is cold. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- scanner: STATICCALL pc 4921, gas const 5000, target 0x01
- decompiled: withdraw() and withdrawAmount(uint256) are owner-only ("Not owner") — an owner sweep, not the same signed act via another path
- owner 0xc25fce14ad46e56632668c9bea30ae5f51d3c7d6 is an EOA; balance 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner sweeps via withdraw(); redeploy without a gas cap if the signed function is still needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
