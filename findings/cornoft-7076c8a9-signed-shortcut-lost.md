---
id: cornoft-7076c8a9-signed-shortcut-lost
title: "CornOFT: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x7076c8a9b401974f807849bf158a793f158d4ef6"
  family: "0fadc9ad78863b9e1fcfb2291e4d78d8"
  copies: 5
  name: "CornOFT"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 1430
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

CornOFT: a signed shortcut (delegateBySig) recovers the holder's key; under EIP-8151 a holder whose address has non-delegation code can no longer use it, while the same act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use delegateBySig; it can still call delegate itself: a way of signing is lost, no right. Rule: permit-like.
- Direct functions present in bytecode at block 26438999 of 0xb1503bcd1fdc48b3173796d1aac5c28e30ba669f (implementation/clone target): approve (0x095ea7b3), transfer (0xa9059cbb), delegate (0x5c19a95c); each acts for msg.sender, so a holder with code calls them itself.
- Signed path(s) lost for a signer with code: delegateBySig; study reading: a holder whose address has code can no longer use delegateBySig; it can still call delegate itself: a way of signing is lost, no right

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 1,430 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Holder with code calls approve/transfer/delegate directly instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
