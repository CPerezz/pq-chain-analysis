---
id: 96008734-fixed-gas-recovery
title: "0x96008734: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x96008734a79a95b4abfd6a10f23aa2eff2ae09e6"
  family: "10354c86c3cd124b4456b3385258ede1"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 18
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "manager"
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
  note: "Tokens can leave through the manager sweep; ETH is only the operator's fee balance (MEDIUM)."
---

## Summary

Token arena game; ETH enters only via update() to pay Oraclize fees, and the randomness callback fails its proof check after EIP-8151.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode has PUSH2 0x0bb8 (3000) as gas with PUSH1 0x01 target before CALL (safer_ecrecover in Oraclize randomDS verifySig); 3000 < 3200 warm cost, so every recovery fails
- no ETH transfer anywhere in decompiled code; update() payable only funds the Oraclize query
- withdraw_all_arina(): require(msg.sender == manager), transfers the contract token balance to the manager
- 0.01 ETH held; value_usd=18; txs_90d=0; last_active=None

## Impact and exposure

- Value held at block 26,438,999: $18 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Manager withdraws tokens and redeploys with a gas-forwarding ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
