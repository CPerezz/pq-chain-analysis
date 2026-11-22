---
id: 3b7fad72-fixed-gas-recovery
title: "0x3b7fad72: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: HIGH
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x3b7fad72773e034a62a595fa59f53f6a5ddd1fc1"
  family: "720ce82aef22ab07c28e12a0f4d8abf6"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "nobody; wallet owners cannot submit a valid signature anymore"
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
  note: "HIGH: no update path, no owner/admin rescue found, and a real (if tiny) native balance is stuck"
---

## Summary

249-byte assembly multisig (EIP-712 signatures, owners in storage, execution by DELEGATECALL); with the 3000-gas call to 0x01 no signature recovers and nothing can be executed.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0xa8-0xad: PUSH1 0x01 PUSH2 0x0bb8 CALL, result POPped, then a recovered>last && is-owner check reverts
- the only exit is the signature-gated DELEGATECALL at 0xec; no owner/admin bypass in the 249-byte bytecode
- balance 1e7 wei native ETH at 26438999; WETH/USDC/USDT/DAI balanceOf(this) all 0; value_usd null, txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on-chain: the balance is stuck; a new wallet would need a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
