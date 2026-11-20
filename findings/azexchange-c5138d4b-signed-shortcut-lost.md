---
id: azexchange-c5138d4b-signed-shortcut-lost
title: "AZExchange: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xc5138d4bd0ec5c51b6b6bdfcb8528ad9c333af97"
  family: "8e91d9553be699387b76ca64021c4255"
  copies: 2
  name: "AZExchange"
  upgradeable: "no"
  rating: LOW
  value_usd: 15339
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3
  last_active: 2026-11-13
fix:
  layer: offchain
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $15339, txs_90d 3."
---

## Summary

AZExchange (EtherDelta clone): an order is valid if placed on chain by its maker or signed by it.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: EtherDelta trade: the order is valid if its maker placed it on chain (orders[user][hash]) or signed it / EtherDelta availableVolume: same test as trade, a view / EtherDelta cancelOrder: the caller…. Read from source.
- order() stores orders[msg.sender][hash] = true (AZExchange.sol:246-249)
- trade/availableVolume/cancelOrder accept orders[user][hash]
- ecrecover(...) == user (256, 292, 308)
- withdraw / withdrawToken pay msg.sender (219, 234)

## Impact and exposure

- Value held at block 26,438,999: $15,339 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-11-13.

## Remediation

The maker places orders with order().

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
