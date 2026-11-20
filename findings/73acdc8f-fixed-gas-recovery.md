---
id: 73acdc8f-fixed-gas-recovery
title: "0x73acdc8f: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: LOW
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x73acdc8ffb42fab481196604812ad8521bed29ca"
  family: "cc47f632f23e163b5775f2bacfe1936d"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: none
  who_acts: "accounts approved by the FsTK authority"
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
  rating: LOW
  note: "LOW: a direct-call way out exists"
---

## Summary

FsTK smart wallet (sibling of 0x1cea…): the signed delegated transfer uses a 3000-gas call to 0x01 and stops; direct transfers stay.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- facts note: 3000-gas call to 0x01 (no dossier; decompiled)
- decompiled: transferEther(address,uint256) and transferToken gated by the authority's msg.sender check, no signature
- balance 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Use direct transferEther/transferToken.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
