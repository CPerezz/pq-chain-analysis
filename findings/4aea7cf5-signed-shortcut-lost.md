---
id: 4aea7cf5-signed-shortcut-lost
title: "0x4aea7cf5 (tagged EtherDelta 1): signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x4aea7cf559f67cedcad07e12ae6bc00f07e8cf65"
  family: "2e0f2234d7bc886b1695b8148a38607f"
  copies: 12
  label: "EtherDelta 1"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 397725
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4
  last_active: 2026-11-09
fix:
  layer: none
  who_acts: "the user (direct withdraw)"
evidence:
  level: bytecode
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
  note: "no path to make an order without a signature: trading dies for a maker whose address holds code, but deposits leave by direct withdraw, so nothing is locked → MEDIUM (scale: the function dies, nothing locked, no update path). Bytecode selectors only. Flagged."
---

## Summary

EtherDelta 1 (bytecode): trade needs the maker's signature; a maker with code cannot have orders filled.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: EtherDelta pattern by its function names. Bytecode and names.
- code.hex has no order() selector 0x0b927666 (unlike later EtherDelta); orders are signed only
- withdraw 0x2e1a7d4d and withdrawToken 0x9e281a98 present, direct
- taker is msg.sender, so taking still works

## Impact and exposure

- Value held at block 26,438,999: $397,725 (ETH and 49 priced tokens, over 12 addresses).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-11-09.

## Remediation

Code-holding users withdraw directly or trade only as taker.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
