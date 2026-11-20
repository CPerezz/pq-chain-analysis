---
id: 277f8862-fixed-gas-recovery
title: "0x277f8862: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x277f8862c386c8dfa1eb1e5f935e5d8edee946e7"
  family: "b96defdff401b1db4c04887586cb1363"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner/operator (or players via refund)"
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
  note: "No update path; the random function dies but the money still leaves through owner/refund paths (MEDIUM per scale)."
---

## Summary

unnamed: Oraclize randomDS game/consumer; after EIP-8151 every proof check fails so randomness-dependent bets never resolve, but ETH can still leave through existing exit/refund functions.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode has PUSH2 0x0bb8 (3000) as gas with PUSH1 0x01 target before CALL (safer_ecrecover in Oraclize randomDS verifySig); 3000 < 3200 warm cost, so every recovery fails
- exit/refund functions present: kill(), unresolved_41c0e1b5
- 0 ETH held; value_usd=None; txs_90d=0; last_active=None
- no proxy slot or upgrade function (row.upgradeable=no)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner refunds/withdraws via the existing exit and redeploys with a gas-forwarding ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
