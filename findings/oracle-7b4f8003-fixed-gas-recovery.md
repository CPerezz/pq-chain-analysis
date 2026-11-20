---
id: oracle-7b4f8003-fixed-gas-recovery
title: "Oracle: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x7b4f8003310f15bd0cd48d76cc68be4ff10bef58"
  family: "0d09fa87ec8dca89e131c7df8a900820"
  copies: 2
  name: "Oracle"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "oracle operator (redeploy)"
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
  note: "Holds nothing and has no update path; only rate updates stop, so MEDIUM. Not verified: that the 0x01 call is reached only from the proof path."
---

## Summary

A token-rate oracle built on Oraclize: updateTokenRates, __callback(bytes32,string,bytes), ENS controllerNode and tokenWhitelistNode, and claim(). Its 3,000-gas ecrecover is in the proof-signature check (Oraclize's safer_ecrecover pattern), so callbacks carrying a proof fail.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0x4637: PUSH1 0x01 PUSH2 0x0bb8 CALL (3,000 gas)
- selectors: __callback(bytes32,string,bytes), updateTokenRates, claim(address,address,uint256), isAdmin(address); the constants include the Oraclize resolver 0x1d3b2638…
- balance 0 at 26438999; family value $0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy the oracle without the gas cap, or with a different proof scheme.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
