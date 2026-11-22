---
id: a1a46554-fixed-gas-recovery
title: "0xa1a46554: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0xa1a465548fe36dcab13cd3150e45037460d425e8"
  family: "f7392037ddc8889a1cf2118208c5c8b0"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 4
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner 0x3baadba0da3f22e5b86581d686a2bde9a54aa0b4 (EOA), via withdraw()"
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
  note: "MEDIUM: the random-DS callback dies for good (no update path), but the owner-sweep withdraw() gets the money out"
---

## Summary

Oraclize random-DS game: the proof check uses safer_ecrecover with a 3000-gas call, so every random-DS callback fails for good and rounds cannot settle.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- scanner: CALL pc 9578, gas const 3000, target 0x01 (Oraclize proofVerify pattern; Oraclize OAR 0x1d3b2638… in constants)
- decompiled: withdraw() is owner-only and sweeps the whole balance to the owner — an owner sweep, not the same callback act via another path
- owner() at 26438999 = 0x3baadba0…, cast code 0x (EOA); balance 0.002 ETH (value_usd 4)

## Impact and exposure

- Value held at block 26,438,999: $4 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner sweeps the balance with withdraw(); a revived game needs a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
