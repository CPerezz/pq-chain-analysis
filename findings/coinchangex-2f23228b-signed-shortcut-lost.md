---
id: coinchangex-2f23228b-signed-shortcut-lost
title: "Coinchangex: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x2f23228b905ceb4734eb42d9b42805296667c93b"
  family: "3997f49cc020c4293cd3b6b040d5a8bf"
  name: "Coinchangex"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 31399
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-10-12
fix:
  layer: none
  who_acts: "nobody (no update path)"
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
  rating: MEDIUM
  note: "No direct way to place an order → LOW does not hold; nothing is locked → MEDIUM (same as peers' Coinchangex-type rows)."
---

## Summary

Coinchangex (EtherDelta-style) exchange with signed orders only; under EIP-8151 a maker with code cannot have orders filled.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Coinchangex trade: the maker named must have signed; no on-chain orders / Coinchangex availableVolume: same test, a view / Coinchangex cancelOrder: the caller must have signed the order. Read from source.
- trade(): ecrecover(...) == user is required; there is no order() / orders[] on-chain path (Coinchangex.sol:322-327)
- withdraw / withdrawToken pay msg.sender directly (Coinchangex.sol:228, 280)
- No upgrade path (facts)

## Impact and exposure

- Value held at block 26,438,999: $31,399 (ETH and 49 priced tokens).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-10-12.

## Remediation

None for makers with code; deposits leave by withdraw.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
