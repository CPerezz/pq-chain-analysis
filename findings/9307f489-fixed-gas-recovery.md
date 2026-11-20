---
id: 9307f489-fixed-gas-recovery
title: "0x9307f489: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x9307f4893416dce16ffd85171db3e6d3f0c290b8"
  family: "0d5270b81713bcb2ee1a070f0fcab271"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 4
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "wallet owner (slot 2), via disbandTo, after cosigner approvals"
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
  note: "MEDIUM: the signed-transfer function dies for good (no update path), but the owner's disband path still gets the money out"
---

## Summary

Cosigner team wallet: transfer and changeAllCosigners need cosigner ECDSA signatures checked against m_cosigners; the 3000-gas CALL to 0x01 fails for every signature, so both stop for good.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- scanner: CALL pc 4469, gas const 3000, target 0x01, result compared with storage (m_cosigners), revert on failure
- decompiled: disbandTo(address) sends the whole balance; it needs msg.sender == slot-2 owner and approveDisband count > 2 — an owner/disband rescue, not the same signed-transfer act via another path
- balance at 26438999: 0.002 ETH (value_usd 4); txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $4 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Cosigners approve disband, then the owner calls disbandTo to move the balance to a new wallet.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
