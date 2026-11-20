---
id: rng-bf43a3f0-fixed-gas-recovery
title: "RNG: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0xbf43a3f0777bf04f9820380b6e4df6e692f7ddb7"
  family: "b00e432e1c05922db9b386ef9718528e"
  name: "RNG"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 1581
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0x974655285b84a7042513b99714e3907991ab7aab (EOA)"
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
  note: "MEDIUM: the RNG service dies for good (no update path); owner's withdraw is a sweep path, not the service restored."
---

## Summary

Oraclize randomDS RNG service contract. Proof verification fails at 3,000 gas so random requests stop; the owner withdraws any ETH.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode: 6000 6001 610bb8 f1, a constant 3,000 gas to 0x01
- withdraw(address,uint256): require(msg.sender == owner), transfers any amount (decompiled)
- owner() = 0x9746…ab7aab, EOA @26438999; balance 0.876 ETH

## Impact and exposure

- Value held at block 26,438,999: $1,581 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for the funds: the owner can call withdraw; the RNG service itself has no update path and stays dead.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
