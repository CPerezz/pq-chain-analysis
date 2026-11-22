---
id: c3c12a9e-signed-shortcut-lost
title: "0xc3c12a9e: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xc3c12a9e63e466a3ba99e07f3ef1f38b8b81ae1b"
  family: "401cb9b286cea2cf237d5083217f43be"
  upgradeable: "no"
  rating: LOW
  value_usd: 182080
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 26
  last_active: 2026-11-16
fix:
  layer: none
  who_acts: "the maker"
evidence:
  level: source-read
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
  note: "Order placement and withdrawal are open by direct call: LOW."
---

## Summary

Unverified EtherDelta clone: EtherDelta-style exchange. A maker's off-chain signed order is checked by ecrecover at fill time unless the maker stored it on chain with order(). A maker with code loses the signed route only.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: EtherDelta pattern by its function names. Bytecode and names.
- order 0x0b927666 (on-chain order flag, msg.sender) present in runtime code at block 26438999; trade skips ecrecover when the flag is set
- withdraw 0x2e1a7d4d / withdrawToken 0x9e281a98 by msg.sender, no signature
- cancelOrder accepts the stored flag for msg.sender

## Impact and exposure

- Value held at block 26,438,999: $182,080 (ETH and 49 priced tokens).
- Activity: 26 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

The maker places orders with order() and withdraws directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
