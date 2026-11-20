---
id: fe17b2bb-fixed-signer
title: "0xfe17b2bb: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfe17b2bb237a4f4c28470ade25be917dfb0da56e"
  family: "f79f8966bd87d5566e8769f9a243088f"
  upgradeable: "no"
  rating: LOW
  txs_90d: 8
  last_active: 2026-11-16
  recoveries_14d: 2
fix:
  layer: none
  who_acts: "owner/relayer"
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
  rating: LOW
  note: "Nothing is held and the swap act is open by a direct call: LOW. Whether 0x3593564c is restricted to the owner was not fully resolved (a guard reads a stack value)."
---

## Summary

Trading router of the same family: signed orders (0xadce8a24/0x60b9af76) recover the constant 0x4c078f5c… (7702-delegated, not real code), submitted by relayer 0x3a062313…. The router execute (0x3593564c) shows no signature requirement, and the contract holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Recent txs: sender 0x3a062313…, recovered 0x4c078f5c… (txs.json).
- Decompile: 0x3593564c has a deadline check and a reentrancy flag but no ecrecover; it refunds the balance to msg.sender.
- Balance 0 ETH and 0 WETH; one token received in 200k blocks, current balance 0.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 8 transactions called it in the 90 days before that block; last on 2026-11-16.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

None.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
