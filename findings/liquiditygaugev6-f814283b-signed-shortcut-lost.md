---
id: liquiditygaugev6-f814283b-signed-shortcut-lost
title: "LiquidityGaugeV6: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xf814283bfd37dc24b2fb5515982f5c0708e508b6"
  family: "d2845f4ac280d646200bac5e9d61b0d8"
  name: "LiquidityGaugeV6"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1339
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

LiquidityGaugeV6: a signed shortcut (permit) recovers the holder's key; under EIP-8151 a holder whose address has non-delegation code can no longer use it, while the same act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Vyper permit (Curve gauge): ecrecover must equal _owner. Read (function text).
- Direct functions present in bytecode at block 26438999: approve (0x095ea7b3), transfer (0xa9059cbb); each acts for msg.sender, so a holder with code calls them itself.
- Signed path(s) lost for a signer with code: permit; study reading: Vyper permit (Curve gauge): ecrecover must equal _owner
- Dossier ~/dev/pq-chain-analysis/goals/eip-8151-analysis/gate1/readings/d2845f4ac280d646200bac5e9d61b0d8 (source + scanner: STATICCALL to precompile 0x01 present).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,339 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Holder with code calls approve/transfer/delegate directly instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
