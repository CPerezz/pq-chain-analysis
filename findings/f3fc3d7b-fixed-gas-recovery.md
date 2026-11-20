---
id: f3fc3d7b-fixed-gas-recovery
title: "0xf3fc3d7b: fixed gas for ecrecover below EIP-8151's price"
status: not-affected
severity: NONE
patterns: [PQ-14]
impact: none
contracts:
- address: "0xf3fc3d7b0761f43f410b44e8bf871a8f3a026b50"
  family: "4def7860ca15ca42e93c88d0626bec4a"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "the 0x01 call has empty input and an ignored result; it is filler, not a signature check"
---

## Summary

Owner-controlled deposit/'checkCondition' contract (chain-dependent obfuscated logic). Its 5000-gas STATICCALL to 0x01 sends empty input, so it never recovers a signature, and the result is popped.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 5000 gas to the precompile: fails when the recovered address is cold. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0xe91-0xe9e: CALLVALUE, CALLER, PUSH0, DUP1, PUSH1 0x01, PUSH2 0x1388, STATICCALL, POP: argsOffset 0, argsSize 0, success discarded
- with empty input the recovery is invalid today too, so EIP-8151 changes nothing about its outcome
- funds leave via withdraw() 0x3ccfd60b and withdrawAmount(uint256), both `msg.sender == owner` with no signature; owner 0xc25Fce14Ad46E56632668C9bea30ae5F51d3c7d6 (EOA)
- balance 0 at block 26438999; txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
