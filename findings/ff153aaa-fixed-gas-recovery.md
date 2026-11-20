---
id: ff153aaa-fixed-gas-recovery
title: "0xff153aaa: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xff153aaab90deb8d88c3e7e9e0737b03a5e8b93c"
  family: "dbf78ecbdd1e40dda42b745b2c7e558c"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "bot operator (signer 0x403c92fa3623a5ffbba3054a4a24a55ceec73b13)"
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
  note: "no update path, and only the operator's own dust is stuck, so MEDIUM despite funds-locked"
---

## Summary

Fallback-only MEV bot: every action, including the transfer to the beneficiary 0x2d722c96...f8, requires a payload signed by an immutable signer, recovered via STATICCALL(3000, 0x01). After activation every call reverts and the 0.00007 ETH it holds stays stuck.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0x1c7-0x1cc: PUSH1 0x01, PUSH2 0x0bb8, STATICCALL; failure jumps to revert 0x898477d6
- signer is an immutable PUSH32 0x403c92fa...3b13 (EOA, cast code 0x); beneficiary 0x2d722c96f79d149dd21e9ef36f93fc12906ce9f8 is a contract
- the decompiled fallback has no unsigned ETH-withdraw path (the unsigned branches are swap callbacks that transfer 0)
- balance 70000000000000 wei at block 26438999; txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy the bot; the 7e-5 ETH dust is lost.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
