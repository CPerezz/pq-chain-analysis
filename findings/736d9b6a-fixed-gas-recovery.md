---
id: 736d9b6a-fixed-gas-recovery
title: "0x736d9b6a: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x736d9b6a58ab142e9ea171fb9cb5c401decbe1d0"
  family: "9a87ef81a71f3d0a35c52011a9dd5ff5"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 39
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0xfd97b6d9977cb009cdf95fac9dd4878b53233b94 (EOA)"
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
  note: "MEDIUM: the draw dies for good (no update path); owner's kill() is a sweep path (sends the pot to the owner, not to new winners), not the draw restored."
---

## Summary

EthereumPot (Oraclize randomDS pot lottery). Pot draws fail at 3,000 gas; winners' already-credited balances and the owner's kill() still move ETH.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode: 6000 6001 610bb8 f1, a constant 3,000 gas to 0x01
- 0xbe26733c kill: if msg.sender == owner(slot 5) selfdestruct(owner); withdrawBalance 0x5fd8c710 pays balances[msg.sender] directly (decompiled)
- slot 5 = 0xfd97…3b94, EOA @26438999; balance 0.0218 ETH

## Impact and exposure

- Value held at block 26,438,999: $39 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for the funds: owner can kill() to recover the pot; the draw itself has no update path and stays dead.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
