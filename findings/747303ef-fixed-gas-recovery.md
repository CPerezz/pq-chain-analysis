---
id: 747303ef-fixed-gas-recovery
title: "0x747303ef: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x747303efe6b7caf07e35657bb72a077720c5cfc6"
  family: "a6a478278c0c7743438833db7e04beac"
  copies: 3
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 11
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0x4a1d6f9bb9a1ad869b9f60873897e524820951c9 plus 3 cosigners (all EOAs)"
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
  note: "MEDIUM: the signed transfer dies for good (no update path); disbandTo is a disband path, not the transfer restored."
---

## Summary

Team wallet: transfer() and changeAllCosigners() need cosigner ECDSA signatures through a 3,000-gas call, so they fail; disbandTo() releases everything after cosigners approve by direct call.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode: 6000 6001 610bb8 f1, a constant 3,000 gas to 0x01, in 0x91f34dbd transfer and 0xa0175b96 changeAllCosigners
- approveDisband() is a direct call by cosigners; disbandTo(address): owner only, after 3 approvals, sends the whole balance (decompiled)
- m_owner and m_cosigners[0..3] all EOAs @26438999; balance 0.006 ETH

## Impact and exposure

- Value held at block 26,438,999: $11 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for the funds: cosigners approveDisband and the owner disbandTo a new wallet; the signed transfer itself has no update path and stays broken.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
