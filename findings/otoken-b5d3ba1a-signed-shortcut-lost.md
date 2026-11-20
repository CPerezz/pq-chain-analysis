---
id: otoken-b5d3ba1a-signed-shortcut-lost
title: "Otoken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb5d3ba1a32ea09f287f9e587e568efcb1e4e53a2"
  family: "145c93a2af0f2aa8c0b54bf5c830f1f3"
  copies: 884
  name: "Otoken"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1471
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

Otoken: a signed shortcut (permit) recovers the holder's key; under EIP-8151 a holder whose address has non-delegation code can no longer use it, while the same act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit: the owner named in the call must equal the recovered address; the holder can call approve itself. Read from source.
- Direct functions present in bytecode at block 26438999 of 0x6aef7dd5180c3ced4f58e55fe99c438bf4f19ba4 (implementation/clone target): approve (0x095ea7b3), transfer (0xa9059cbb); each acts for msg.sender, so a holder with code calls them itself.
- Signed path(s) lost for a signer with code: permit; study reading: permit: the owner named in the call must equal the recovered address; the holder can call approve itself
- Dossier ~/dev/pq-chain-analysis/goals/eip-8151-analysis/readings/145c93a2af0f2aa8c0b54bf5c830f1f3 (source + scanner: STATICCALL to precompile 0x01 present).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 884 addresses).
- Activity: 1,471 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Holder with code calls approve/transfer/delegate directly instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
