---
id: 7a26f7fc-fixed-gas-recovery
title: "0x7a26f7fc: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x7a26f7fc44a0efcd7b156419269ff4895828d871"
  family: "f5341cc1efc01363d6c5f9bf7ba29e36"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator (redeploy)"
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
  note: "Nothing held and no update path: only a function stops, so MEDIUM."
---

## Summary

A 23.9 KB order-filling bot (selectors fillOrderArgs, fillContractOrderArgs, hashOrder, bitInvalidatorForOrder). One of its ECDSA order-signature checks sends 3,000 gas to 0x01, so that path fails.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode at 0x3715: PUSH1 0x01 PUSH2 0x0bb8 STATICCALL; other calls in the code (0x24b6, 0x26a0) send 50,000 gas to a computed address, not to 0x01
- selectors resolved from the bytecode: fillOrderArgs, fillContractOrderArgs, extsload, token0/token1
- balance 0 at 26438999; family value $0; no exits or setters found

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The operator redeploys with uncapped ecrecover gas.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
