---
id: bd311e4e-fixed-gas-recovery
title: "0xbd311e4e: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0xbd311e4e6edf55532d71a1a7265e4482ae391c9d"
  family: "58f9d6f8f334f0097ecfb3cabc61b30a"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "FsTK admin (authority-approved caller)"
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
  note: "The signed function dies for good (the gas is a code constant, no update path); the admin's transferEther and transferToken still move the money without a signature, so nothing is locked: MEDIUM."
---

## Summary

An FsTK issuer/vendor contract whose signed voucher or issue function (0x20b7e245) recovers a signature with 3,000 gas, so it stops working. ETH and tokens can still leave through admin functions that need no signature.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0x271c-0x2721: PUSH1 0x01 PUSH2 0x0bb8 STATICCALL
- decompile: transferEther(address,uint256) and transferToken(address,address,uint256) are gated by authority 0x0a85bb25(msg.sender), with no signature
- balance 0 at 26438999; family value $0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin moves any funds out with transferEther/transferToken and redeploys the issuer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
