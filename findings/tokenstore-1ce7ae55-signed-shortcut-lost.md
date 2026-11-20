---
id: tokenstore-1ce7ae55-signed-shortcut-lost
title: "TokenStore: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x1ce7ae555139c5ef5a57cc8d814a867ee6ee33d8"
  family: "13af5b8e797258873f7e456a8c10b390"
  copies: 3
  name: "TokenStore"
  label: "Token.Store"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 1144271
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 72
  last_active: 2026-11-13
fix:
  layer: none
  who_acts: "the user (direct withdraw)"
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
  note: "no path to make an order without a signature: trading dies for a maker whose address holds code, but deposits leave by direct withdraw, so nothing is locked → MEDIUM (scale: the function dies, nothing locked, no update path). Flagged."
---

## Summary

Token.Store exchange: trade requires the maker's signature (no on-chain orders); a maker with code cannot have orders filled.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: TokenStore trade: the maker named must have signed the order; there are no on-chain orders; balances leave by withdraw / TokenStore availableVolume: the same test as trade, a view / TokenStore…. Read from source.
- TokenStore.sol:215-222 trade checks ecrecover(...) == _user; no order() function exists
- TokenStore.sol:174/194 withdraw/withdrawToken direct; the taker is msg.sender (can still take)

## Impact and exposure

- Value held at block 26,438,999: $1.1M (ETH and 49 priced tokens, over 3 addresses).
- Activity: 72 transactions called it in the 90 days before that block; last on 2026-11-13.

## Remediation

Code-holding users withdraw directly or trade only as taker.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
