---
id: cab3f6cd-signed-shortcut-lost
title: "0xcab3f6cd: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xcab3f6cd6a2786cc8b2018224f48437a27506e35"
  family: "48b529f31bdff9838116b47a945827db"
  copies: 4
  upgradeable: "yes"
  rating: LOW
  txs_90d: 1448
  last_active: 2026-11-17
  recoveries_14d: 103
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

unnamed token: a signed shortcut (permit, transferWithAuthorization/receiveWithAuthorization) recovers the holder's key; under EIP-8151 a holder whose address has non-delegation code can no longer use it, while the same act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use cancelAuthorization, permit, receiveWithAuthorization, transferWithAuthorization; it can still call approve, transfer itself: a way of signing is…. Rule: permit-like. Executed: a real transaction reverts with code at the signer.
- Direct functions present in bytecode at block 26438999: approve (0x095ea7b3), transfer (0xa9059cbb); each acts for msg.sender, so a holder with code calls them itself.
- Signed path(s) lost for a signer with code: permit, transferWithAuthorization/receiveWithAuthorization; study reading: a holder whose address has code can no longer use cancelAuthorization, permit, receiveWithAuthorization, transferWithAuthorization; it can still call approve, transfer itself: a way of signing is lost, no right
- Source and scanner: a STATICCALL to precompile 0x01 is present.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 1,448 transactions called it in the 90 days before that block; last on 2026-11-17.
- 103 signature recoveries in the study's two-week trace window.

## Remediation

Holder with code calls approve/transfer/delegate directly instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
