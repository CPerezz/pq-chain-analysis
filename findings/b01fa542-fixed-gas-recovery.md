---
id: b01fa542-fixed-gas-recovery
title: "0xb01fa542: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0xb01fa542a9f60381df625454480b60f03442b2f4"
  family: "802fa95d9516c542e444941c95848385"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner 0xdb92f324… (redeploy)"
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
  note: "Holds nothing and has no update path; a function stops, so MEDIUM. Whether an owner-only token exit exists was not checked."
---

## Summary

A Vyper contract with getSignerAddress(bytes32,bytes), coins(uint256), approve and transfer; it recovers a signer with 3,000 gas and ignores the call's success flag, so every recovery reads back as 0 and the signed actions fail.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0x2cb-0x2d0: PUSH1 0x01 PUSH2 0x0bb8 CALL, then POP (success ignored) and MLOAD of the output
- selectors resolved: getSignerAddress(bytes32,bytes), coins(uint256), owner(); owner() = 0xdb92f3247a9098d017b281fefeaae0866755129a
- balance 0 at 26438999; family value $0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a working recovery.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
