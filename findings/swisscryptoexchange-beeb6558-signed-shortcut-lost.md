---
id: swisscryptoexchange-beeb6558-signed-shortcut-lost
title: "SwissCryptoExchange: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xbeeb655808e3bdb83b6998f09dfe1e0f2c66a9be"
  family: "9c87a0ff315d849b42e2503a43121f9b"
  name: "SwissCryptoExchange"
  upgradeable: "no"
  rating: LOW
  value_usd: 14076
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5
  last_active: 2026-08-25
fix:
  layer: offchain
  who_acts: "maker with code"
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
  note: "The same act (placing an order) stays open by a direct call for the same party. Value $14076, txs_90d 5 (not rating inputs)."
---

## Summary

SwissCryptoExchange, an EtherDelta-style exchange: trade() accepts an order when the maker placed it on chain or signed it. Under EIP-8151 a maker whose address has code can't use a signed order, but can still place it on chain.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: SwissCryptoExchange (EtherDelta fork): true when the user named signed; orders can also be placed on chain. Read from source.
- source (9c87a0ff315d849b42e2503a43121f9b): order() sets orders[msg.sender][hash]=true; the trade check is orders[user][hash]
- ecrecover(...)==user
- deposit/withdraw are direct msg.sender calls; cancelOrder also accepts the on-chain order

## Impact and exposure

- Value held at block 26,438,999: $14,076 (ETH and 49 priced tokens).
- Activity: 5 transactions called it in the 90 days before that block; last on 2026-08-25.

## Remediation

A maker with code places orders with order() and cancels them directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
