---
id: etherdelta-373c55c2-signed-shortcut-lost
title: "EtherDelta: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x373c55c277b866a69dc047cad488154ab9759466"
  family: "6e0c5d249d2919b3ff774c1c9cafd172"
  copies: 2
  name: "EtherDelta"
  upgradeable: "no"
  rating: LOW
  value_usd: 175584
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5
  last_active: 2026-11-09
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

EtherDelta: EtherDelta-style exchange. A maker's off-chain signed order is checked by ecrecover at fill time unless the maker stored it on chain with order(). A maker with code loses the signed route only.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: EtherDelta trade (original): the order was placed on chain by its maker, or signed / EtherDelta availableVolume (original): same test / EtherDelta cancelOrder (original): the caller placed the order…. Read from source.
- order 0x0b927666 (on-chain order flag, msg.sender) present in runtime code at block 26438999; trade skips ecrecover when the flag is set
- withdraw 0x2e1a7d4d / withdrawToken 0x9e281a98 by msg.sender, no signature
- cancelOrder accepts the stored flag for msg.sender

## Impact and exposure

- Value held at block 26,438,999: $175,584 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 5 transactions called it in the 90 days before that block; last on 2026-11-09.

## Remediation

The maker places orders with order() and withdraws directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
