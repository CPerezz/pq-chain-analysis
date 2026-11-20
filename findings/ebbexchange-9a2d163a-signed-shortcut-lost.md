---
id: ebbexchange-9a2d163a-signed-shortcut-lost
title: "EbbExchange: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x9a2d163ab40f88c625fd475e807bbc3556566f80"
  family: "ab384fd43dd30a7c5a2c0f219287e6d8"
  copies: 32
  name: "EbbExchange"
  label: "SingularX"
  upgradeable: "no"
  rating: LOW
  value_usd: 1544884
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 21
  last_active: 2026-11-16
fix:
  layer: account-migration
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
  note: "Same act open by direct call → LOW."
---

## Summary

SingularX (EtherDelta fork): an order is valid if placed on chain or signed; a code-holding maker's signatures fail.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: EtherDelta trade: the order is valid if its maker placed it on chain (orders[user][hash]) or signed it / EtherDelta availableVolume: same test as trade, a view / EtherDelta cancelOrder: the caller…. Read from source.
- Dex.sol:246 order(...) places the order on chain by the maker
- Dex.sol:219/234 withdraw/withdrawToken direct
- Dex.sol:306 cancelOrder accepts on-chain orders of msg.sender

## Impact and exposure

- Value held at block 26,438,999: $1.5M (ETH and 49 priced tokens, over 32 addresses).
- Activity: 21 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

Makers use order() on chain.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
