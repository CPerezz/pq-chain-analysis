---
id: game-e150b693-fixed-gas-recovery
title: "GAME: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0xe150b693404a433b1c822c113f3fa84fe8e2c255"
  family: "f64ec9dc7ee4a1b1d99cb88f1a3f38d9"
  copies: 19
  name: "GAME"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 4621
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0x4468bab1b1d16ee3b9610f7e16eb25af80f85a39 (EOA)"
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
  note: "MEDIUM: draws die for good (no update path); owner's takeAll is a sweep path, not the draw restored."
---

## Summary

Oraclize randomDS ticket lottery (GAME). The 3,000-gas ecrecover in the proof check fails, so draws stop; the owner can still take the whole balance.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: every valid signature fails: the code gives the precompile 3,000 gas. Bytecode.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode: 6000 6001 610bb8 f1, a constant 3,000 gas to 0x01
- takeAll(): require(msg.sender == owner); transfers address(this).balance to the owner (decompiled)
- owner() = 0x4468…5a39, EOA @26438999; balance 0.96 ETH; Oraclize cb EOA inactive since before block 20M

## Impact and exposure

- Value held at block 26,438,999: $4,621 (ETH and 49 priced tokens, over 19 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for the funds: the owner can call takeAll; the draw itself has no update path and stays dead.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
