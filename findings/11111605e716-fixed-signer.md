---
id: 11111605e716-fixed-signer
title: "0x11111605: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x11111605e716b77d9787df71865776826f4c5afe"
  family: "850428fb6cfe5441d0cb885b3c55e71e"
  copies: 3
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 83
  last_active: 2026-11-17
  recoveries_14d: 42
fix:
  layer: new-deployment
  who_acts: "executor operator"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "The function dies for good, but nothing is locked: the swap reverts atomically, and users can route through other executors."
---

## Summary

A swap executor called by 1inch routers through execute(address). Inside the swap it requires a signature by the constant 0x4447…7b76 (an EOA, embedded in the code). If that key gets code, swaps routed through this executor revert. Swaps are atomic, and the executor holds 1 wei, so no user funds are locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: swap executor: a signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- debug_traceTransaction 0x18e2… and 0x9f9d…: ecrecover inside 0x1111… returns 0x4447696e…7b76 (scanner flow eq_const)
- Bytecode contains 0x4447…7b76, which has no code; no setter or upgrade
- balance 1 wei; calls come from 1inch routers 0x1111111254… and 0x111111125421…

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 83 transactions called it in the 90 days before that block; last on 2026-11-17.
- 42 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new executor with a new signer key and route to it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
