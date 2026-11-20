---
id: oracle-cfd5b40f-fixed-gas-recovery
title: "Oracle: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0xcfd5b40f4332cfdc384cf7b7ff0a0c1f214a3a76"
  family: "1aad1a8a5155e2016b363631b90865e6"
  copies: 2
  name: "Oracle"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "admin resolved via ENS (isAdmin)"
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
  note: "The signed function dies for good (the gas is a code constant, no update path); the admin's withdraw still moves the money without a signature, so nothing is locked: MEDIUM."
---

## Summary

An Oraclize-based oracle or token list (__callback with a proof, tokens, removeTokens, withdraw). The proof-signature ecrecover sends 3,000 gas, so callbacks with a proof fail; the admin can still withdraw without a signature.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0x53d7-0x53dc: PUSH1 0x01 PUSH2 0x0bb8 CALL
- decompile withdraw(address,uint256): resolves the controller through ENS (0x0178b8bf/0x3b3b57de), then checks 0xb429afeb(msg.sender) as admin; no signature
- balance 0 at 26438999; family value $0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin uses withdraw if needed and redeploys the oracle.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
