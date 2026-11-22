---
id: 5995ca61-signed-shortcut-lost
title: "0x5995ca61: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x5995ca61d845e045cd1327a32707a66f7daccf6d"
  family: "4b6d7aa4cb7dac896e6ed8e5c2729bb7"
  upgradeable: "no"
  rating: LOW
  value_usd: 137147
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-08-20
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

Unverified EtherDelta-pattern exchange: EtherDelta-style exchange. A maker's off-chain signed order is checked by ecrecover at fill time unless the maker stored it on chain with order(). A maker with code loses the signed route only.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: EtherDelta pattern by its function names. Bytecode and names.
- heimdall decompile (scratch L025/d59): order(...) and orders(address,bytes32) present; cancelOrder accepts storage flag for msg.sender
- withdraw 0x2e1a7d4d and withdrawToken 0x9e281a98 by msg.sender (decompile lines 334-415)
- Note: the order selector differs from EtherDelta's 0x0b927666 (variant signature)

## Impact and exposure

- Value held at block 26,438,999: $137,147 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-08-20.

## Remediation

The maker places orders with order() and withdraws directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
