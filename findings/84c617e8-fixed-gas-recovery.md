---
id: 84c617e8-fixed-gas-recovery
title: "0x84c617e8: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: CRITICAL
patterns: [PQ-14]
impact: funds-loss
contracts:
- address: "0x84c617e83d37e784727e61671a00685e624581cb"
  family: "dc796ce4ebbe4730611438b06b017c91"
  upgradeable: "no"
  rating: CRITICAL
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "nobody can fix it in place: the operator moves to a new deployment"
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
  rating: CRITICAL
  note: "Same Fuel v1 build as 0x6880f6fd and 0xb1a71b35 (the 3,000-gas CALL at pc 0x2a70 pops its success flag and reads a junk address), where the study executed a fraud proof that convicts an honest block and pays out the bond: a wrong verdict punishes an operator who did nothing. Rated by mechanism; it holds $0 and is inactive: CRITICAL."
---

## Summary

A Fuel v1-style optimistic rollup (commitBlock, proveInvalidWitness, proveDoubleSpend, withdraw(bytes), bondWithdraw). Its witness-signature check sends 3,000 gas to 0x01, so every valid signature fails recovery, and fraud proofs and transactions that depend on that check break.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0x2a70-0x2a75: PUSH1 0x01 PUSH2 0x0bb8 CALL
- selectors resolved from the bytecode: proveInvalidWitness(bytes), withdraw(bytes), bondWithdraw(bytes), operator(); operator() = 0xf87ac6f711854af3073efe9d4a3e0809876d61c8
- balance 0 at 26438999; family value $0; txs_90d 0; no proxy

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy the rollup contract with uncapped ecrecover gas.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
