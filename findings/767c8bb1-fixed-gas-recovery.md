---
id: 767c8bb1-fixed-gas-recovery
title: "0x767c8bb1: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x767c8bb1574bee5d4fe35e27e0003c89d43c5121"
  family: "970ef5c4c8a8b2b649eb4970fdd75a26"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "bot operator (redeploy)"
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
  note: "No update path; only the operator's own dust is at stake, and no owner withdraw without a signature was found, so MEDIUM."
---

## Summary

A trading bot that runs every order through its fallback, and each order must carry a signature from the hardcoded signer 0x403c92fa…3b13. With 3,000 gas the recovery always fails, so the bot stops working.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0x1c7-0x1cc: PUSH1 0x01 PUSH2 0x0bb8 STATICCALL (3,000 gas to 0x01)
- decompiled fallback: require(recovered == 0x403c92fa3623a5ffbba3054a4a24a55ceec73b13) before every swap path
- balance at 26438999: 7.44e-6 ETH plus about $0.014 USDC (gate1 universe); no proxy and no upgrade function

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The operator deploys a new bot that does not cap the gas sent to ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
