---
id: cillionaire-663a5ca0-fixed-gas-recovery
title: "Cillionaire: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x663a5ca0295231b0d88afb1c557a8d8f4c1b6459"
  family: "58ded20431717e1b385f86c7677127fa"
  name: "Cillionaire"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 319
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0x3baadba0da3f22e5b86581d686a2bde9a54aa0b4 (EOA)"
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
  note: "MEDIUM: the draw dies for good (no update path); owner's kill() is a disband/sweep path, not the draw restored."
---

## Summary

Cillionaire donation lottery (Oraclize randomDS). The draw's proof check fails at 3,000 gas; the owner can selfdestruct the contract to recover its balance.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode: 6000 6001 610bb8 f1, a constant 3,000 gas to 0x01
- kill() 0x41c0e1b5: require(owner == msg.sender); selfdestruct(owner) (decompiled); donate() forwards donations to the beneficiary immediately
- owner 0x3baa…a0b4 EOA; state()=1; balance 0.177 ETH

## Impact and exposure

- Value held at block 26,438,999: $319 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for the funds: owner calls kill() to recover the balance; the draw itself has no update path and stays dead.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
