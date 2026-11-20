---
id: wyvernexchange-1e8a671d-signed-shortcut-lost
title: "WyvernExchange: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x1e8a671d2fb592f2a0df9fd58ec66c000f6c454c"
  family: "e2853c9aef164cee3d844852a6521d84"
  copies: 5
  name: "WyvernExchange"
  label: "OpenSea: Wyvern Exchange v1"
  upgradeable: "no"
  rating: LOW
  value_usd: 26707
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $26707, txs_90d 0."
---

## Summary

Wyvern exchange: an order is valid if its maker approved it on chain or signed it.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Wyvern validateOrder: valid if the maker approved it on chain by its own call, or signed it. Read from source.
- validateOrder: approvedOrders[hash] accepted before ecrecover(...) == order.maker (WyvernExchange.sol:673-678)
- approveOrder_ lets the maker store the approval by its own call (WyvernExchange.sol:700-707, 1220)
- Same party in both paths

## Impact and exposure

- Value held at block 26,438,999: $26,707 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The maker calls approveOrder_ instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
