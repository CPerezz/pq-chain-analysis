---
id: a9b17f57-signed-shortcut-lost
title: "0xa9b17f57: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xa9b17f572341219703bc951725bdb3ca756b1a65"
  family: "27febc1266c5681e35df36ab3e490eaf"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  txs_90d: 1448
  last_active: 2026-11-18
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

unnamed token: a signed shortcut (delegatedTransfer (signed transfer)) recovers the holder's key; under EIP-8151 a holder whose address has non-delegation code can no longer use it, while the same act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: as its template 74d8e4dd: delegated transfer: whoever signed is the holder that pays; a holder can call transfer itself. Template.
- Direct functions present in bytecode at block 26438999 of 0xcafe1ebf45f32b6302ff15e1e9c2026b54c0ec45 (implementation/clone target): approve (0x095ea7b3), transfer (0xa9059cbb); each acts for msg.sender, so a holder with code calls them itself.
- Signed path(s) lost for a signer with code: delegatedTransfer (signed transfer); study reading: as its template 74d8e4dd: delegated transfer: whoever signed is the holder that pays; a holder can call transfer itself

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,448 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Holder with code calls approve/transfer/delegate directly instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
