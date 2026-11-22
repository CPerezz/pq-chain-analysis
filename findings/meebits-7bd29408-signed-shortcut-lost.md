---
id: meebits-7bd29408-signed-shortcut-lost
title: "Meebits: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x7bd29408f11d2bfc23c34f18275bbf23bb716bc7"
  family: "b02d5742f061fa246cac57d65a2894cb"
  name: "Meebits"
  label: "Meebits: ⚇ Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 273932
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3129
  last_active: 2026-11-17
fix:
  layer: none
  who_acts: "the affected holder (calls the direct function itself)"
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
  note: "The holder keeps direct transfer and approve; only the atomic signed swap is lost: LOW."
---

## Summary

Meebits ERC-721 with signed trade offers (maker signs, taker accepts). A maker whose address has code cannot have offers accepted; it can still transfer its tokens itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Meebits trade offers: maker and taker of an off-chain trade must have signed; a holder can always transfer its token itself. Read from source.
- Meebits.sol:265-273 safeTransferFrom/transferFrom by owner or approved (canTransfer)
- Meebits.sol:591-632 tradeValid/acceptTrade need the maker signature; cancelOffer direct
- approve 0x095ea7b3 in runtime code at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $273,932 (ETH and 49 priced tokens).
- Activity: 3,129 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The holder transfers or approves directly, or trades through a marketplace.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
