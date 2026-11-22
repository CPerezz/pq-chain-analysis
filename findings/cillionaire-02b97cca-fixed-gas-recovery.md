---
id: cillionaire-02b97cca-fixed-gas-recovery
title: "Cillionaire: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x02b97cca6d6a5227e464b2a60ee1a580ea4f7da9"
  family: "52b7d34cb616b806198506fd45ce92cd"
  name: "Cillionaire"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 18
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0x3baadba0da3f22e5b86581d686a2bde9a54aa0b4"
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
  note: "MEDIUM: only the operator's own reserve is affected and the draw function stops; no update path."
---

## Summary

Cillionaire donation lottery (no kill()). The Oraclize draw fails at 3,000 gas; donations are forwarded to the beneficiary on receipt, so only the operator's 0.01 ETH reserve remains.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode: 6000 6001 610bb8 f1, a constant 3,000 gas to 0x01
- withdraw() 0x3ccfd60b: owner only, require(balance > 0.01 ETH), sends balance - 0.01 ETH; donate() forwards msg.value - fee to the beneficiary (decompiled)
- balance exactly 0.01 ETH, state()=1, owner EOA

## Impact and exposure

- Value held at block 26,438,999: $18 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None; the 0.01 ETH reserve is not withdrawable even today.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
