---
id: ledgerrandomproofverifier-aa8786ee-fixed-gas-recovery
title: "LedgerRandomProofVerifier: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0xaa8786eecd289fa7dd48a35ea31493bb67626623"
  family: "c3529bc6fd8e884e3922bbf8683a1d23"
  copies: 2
  name: "LedgerRandomProofVerifier"
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
  note: "Only a helper function stops / only the operator's own fee balance is stuck (MEDIUM)."
---

## Summary

LedgerRandomProofVerifier: Oraclize random-number helper/consumer; after EIP-8151 its proof check always fails, so it can no longer deliver randomness; its ETH only prefunds Oraclize query fees (owner-supplied).

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode has PUSH2 0x0bb8 (3000) as gas with PUSH1 0x01 target before CALL (safer_ecrecover in Oraclize randomDS verifySig); 3000 < 3200 warm cost, so every recovery fails
- no user deposit/payout path: non-view functions are Unresolved_96fe6e74, Unresolved_ac0379da, Unresolved_c629061d
- 0 ETH held; value_usd=None; txs_90d=0; last_active=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Operator redeploys with a gas-forwarding ecrecover (or another randomness source).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
