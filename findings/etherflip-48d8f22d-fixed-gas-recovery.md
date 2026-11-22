---
id: etherflip-48d8f22d-fixed-gas-recovery
title: "EtherFlipGold: fixed gas for ecrecover below EIP-8151's price"
project: etherflip
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x48d8f22d45e40f34cb7c10799f31246f134e9b7f"
  family: "2e5ba8f711a5325c5fe13689650786c9"
  name: "EtherFlipGold"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 29148
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the owner refunds open bets and moves the bankroll before activation"
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
  note: "as EtherFlip"
---

## Summary

`EtherFlipGold` at `0x48d8f22d45e40f34cb7c10799f31246f134e9b7f`. The same design as EtherFlip: its Oraclize proof check gives ecrecover 3,000 gas, so from activation day no bet resolves; the owner moves the money without a signature.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: every valid signature fails: the code gives the precompile 3,000 gas. Bytecode.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Same Oraclize code as EtherFlip (safer_ecrecover with a constant 3,000 gas, result flag ignored).
- refundTransfer and updateOwner present; the owner is 0x165c74e3954817d007a2038bac8eaaed87c982fa, as for EtherFlip.
- No proxy, no upgrade. No transaction in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $29,148 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner refunds and withdraws before activation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
