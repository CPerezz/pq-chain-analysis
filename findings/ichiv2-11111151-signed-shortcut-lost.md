---
id: ichiv2-11111151-signed-shortcut-lost
title: "IchiV2: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x111111517e4929d3dcbdfa7cce55d30d4b6bc4d6"
  family: "7eec2d879ff956b7e9772f77a8ce99e4"
  name: "IchiV2"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1088
  last_active: 2026-11-17
fix:
  layer: offchain
  who_acts: "the affected holder (calls the direct function itself)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Direct path exists for the same party (msg.sender-based approve/transfer/delegate); only a way of signing is lost, so LOW."
---

## Summary

IchiV2: a signed shortcut (permit, delegateBySig) recovers the holder's key; under EIP-8151 a holder whose address has non-delegation code can no longer use it, while the same act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: as its template d927799d: permit: the owner named in the call must equal the recovered address; the holder can call approve itself / Compound delegateBySig (variant). Template.
- Direct functions present in bytecode at block 26438999: approve (0x095ea7b3), transfer (0xa9059cbb), delegate (0x5c19a95c); each acts for msg.sender, so a holder with code calls them itself.
- Signed path(s) lost for a signer with code: permit, delegateBySig; study reading: as its template d927799d: permit: the owner named in the call must equal the recovered address; the holder can call approve itself / Compound delegateBySig (variant)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,088 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Holder with code calls approve/transfer/delegate directly instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
