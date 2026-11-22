---
id: c6b330df-signed-shortcut-lost
title: "0xc6b330df: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xc6b330df38d6ef288c953f1f2835723531073ce2"
  family: "66e9a90643cc05b4f1ba2f1da19e0f71"
  copies: 15
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 30317
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody (no update path)"
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
  note: "No direct way to place an order (order() only broadcasts) → LOW does not hold; nothing is locked → MEDIUM, as for Coinchangex. Bytecode plus traced call."
---

## Summary

Unverified EtherDelta-pattern exchange: signed orders recover to their maker; under EIP-8151 a maker with code cannot sign orders.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: EtherDelta pattern by its function names. Bytecode and names.
- Decompile: trade (0x0a19b14a) and the test path compare ecrecover(...) with the maker; no stored-order check (heimdall, scratch L027)
- EtherDelta's storing order() selector 0x0b927666 is absent from the bytecode; the present order(...,v,r,s) 0x93f0bb51 only emits an event: debug_traceCall prestate diff at block 26438999 shows no storage write to the contract
- withdraw / withdrawToken pay msg.sender (heimdall, facts exits); no setter or upgrade path (facts)

## Impact and exposure

- Value held at block 26,438,999: $30,317 (ETH and 49 priced tokens, over 15 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for makers with code; deposits leave by withdraw.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
