---
id: bitlagio-fa65bb26-fixed-gas-recovery
title: "Bitlagio: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0xfa65bb26b28e7f923f73248a9a47a5466d9cc7ec"
  family: "e7a57a7c320f42aa7060e39b5262b4c7"
  name: "Bitlagio"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 4782
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0x9a9236dabd08652c140e8931849c79f9c4d78607 (EOA)"
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
  note: "MEDIUM: betting dies for good (no update path); owner's withdrawFromPot is a sweep path, not the same act restored, so it does not fall to LOW."
---

## Summary

Bitlagio, an Oraclize randomDS betting game. With 3,000 gas the Oraclize proof's ecrecover always fails, so bets can no longer settle; the bankroll still leaves through the owner.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: every valid signature fails: the code gives the precompile 3,000 gas. Bytecode.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode: PUSH1 0x01 PUSH2 0x0bb8 CALL (6000 6001 610bb8 f1), a constant 3,000 gas to 0x01
- withdrawFromPot(uint256) 0x128e1af0: require(owner == msg.sender), transfers any amount to the owner (decompiled)
- owner() = 0x9a92…8607, cast code 0x (EOA) @26438999; balance 2.65 ETH
- Oraclize callback EOA 0x26588a…2d51: nonce 584553 and balance 0 at blocks 20M and 26438999, so callbacks had already stopped

## Impact and exposure

- Value held at block 26,438,999: $4,782 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for the funds: the owner can drain the pot with withdrawFromPot; betting itself has no update path and stays broken.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
