---
id: 4d55f76c-signed-shortcut-lost
title: "0x4d55f76c: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x4d55f76ce2dbbae7b48661bef9bd144ce0c9091b"
  family: "d700ed878665a8535982ce44d51b3e3e"
  upgradeable: "no"
  rating: LOW
  value_usd: 4473685
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 49
  last_active: 2026-10-03
fix:
  layer: account-migration
  who_acts: "the maker"
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
  rating: LOW
  note: "Same act (place order) open on chain → LOW. Bytecode selectors only."
---

## Summary

EtherDelta-style exchange (bytecode): orders placed on chain or signed; a code-holding maker's signed orders fail.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: EtherDelta by its function names: an order is placed on chain or signed; balances leave by withdraw. Bytecode and names.
- code.hex has order(address,uint256,address,uint256,uint256,uint256) selector 0x0b927666 (on-chain order)
- code.hex has withdraw 0x2e1a7d4d and withdrawToken 0x9e281a98, direct calls
- cancelOrder 0x278b8c0e present

## Impact and exposure

- Value held at block 26,438,999: $4.5M (ETH and 49 priced tokens).
- Activity: 49 transactions called it in the 90 days before that block; last on 2026-10-03.

## Remediation

Makers place orders on chain with order().

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
