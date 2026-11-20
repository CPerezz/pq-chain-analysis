---
id: mobius2dv2-b4a44838-fixed-gas-recovery
title: "Mobius2Dv2: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: LOW
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0xb4a448387403554616eb5b50aa4c48f75243a015"
  family: "b063805f94cf9b39667802b7b2b854b3"
  name: "Mobius2Dv2"
  upgradeable: "yes"
  admin: "0x853012bce9eacabc6e9047be9630a7e6b3739a7a (EOA)"
  rating: LOW
  value_usd: 10
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-11-03
fix:
  layer: contract-upgrade
  who_acts: "owner 0x853012bce9eacabc6e9047be9630a7e6b3739a7a"
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
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: the update path is held by a live EOA owner. The upgrade(address) function itself comes from the study, not from my own reading."
---

## Summary

Mobius2Dv2: calls the precompile with 3000 gas, below EIP-8151's 3,200/6,100, so every valid signature fails.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: upgrade(address), owner 0x853012bce9eacabc6e9047be9630a7e6b3739a7a.
- owner() = 0x853012…7a7a at block 26438999
- 0x853012…7a7a: no code, nonce 132 at block 26438999
- row: upgrade(address) callable by the owner (study reading; not re-read)

## Impact and exposure

- Value held at block 26,438,999: $10 (ETH and 49 priced tokens).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-11-03.

## Remediation

Owner calls upgrade(address) to a version forwarding enough gas to ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
