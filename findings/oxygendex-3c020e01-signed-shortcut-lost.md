---
id: oxygendex-3c020e01-signed-shortcut-lost
title: "OxygenDEX: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x3c020e014069df790d4f4e63fd297ba4e1c8e51f"
  family: "5182900a2a4e6720ef6f3e93010b1a2d"
  copies: 6
  name: "OxygenDEX"
  label: "Bitcratic"
  upgradeable: "no"
  rating: LOW
  value_usd: 54317
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 36
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

OxygenDEX (Bitcratic): EtherDelta-style exchange. A maker's off-chain signed order is checked by ecrecover at fill time unless the maker stored it on chain with order(). A maker with code loses the signed route only.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: EtherDelta trade: the order is valid if its maker placed it on chain (orders[user][hash]) or signed it / EtherDelta availableVolume: same test as trade, a view / EtherDelta cancelOrder: the caller…. Read from source.
- order 0x0b927666 (on-chain order flag, msg.sender) present in runtime code at block 26438999; trade skips ecrecover when the flag is set
- withdraw 0x2e1a7d4d / withdrawToken 0x9e281a98 by msg.sender, no signature
- cancelOrder accepts the stored flag for msg.sender

## Impact and exposure

- Value held at block 26,438,999: $54,317 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 36 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

The maker places orders with order() and withdraws directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
