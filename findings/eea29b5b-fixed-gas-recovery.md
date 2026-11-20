---
id: eea29b5b-fixed-gas-recovery
title: "0xeea29b5b: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: HIGH
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xeea29b5b5ae2e0e611d980152f9fbc893bc7c179"
  family: "5bbae606e8c9b85d2f6fcd84746e7869"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "none (no update path); players cannot recover"
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
  note: "No update path and no function moves player funds without the proof check."
---

## Summary

unnamed: Oraclize randomDS game; after EIP-8151 every proof check fails, so the draw never completes and players' ETH stays in the contract.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode has PUSH2 0x0bb8 (3000) as gas with PUSH1 0x01 target before CALL (safer_ecrecover in Oraclize randomDS verifySig); 3000 < 3200 warm cost, so every recovery fails
- BalloonsX9 copy: no non-callback function moves ETH; players' pot pays only in __callback
- 0 ETH held; value_usd=None; txs_90d=0; last_active=None
- no proxy slot or upgrade function (row.upgradeable=no)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on-chain; the contract cannot be fixed or drained.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
