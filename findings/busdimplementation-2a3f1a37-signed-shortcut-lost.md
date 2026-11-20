---
id: busdimplementation-2a3f1a37-signed-shortcut-lost
title: "BUSDImplementation: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x2a3f1a37c04f82aa274f5353834b2d002db91015"
  family: "74d8e4dd3aeeeedd9d3162d56467f919"
  copies: 2
  name: "BUSDImplementation"
  label: "Paxos: BUSD Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 70017
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 68763
  last_active: 2026-11-18
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
  note: "Same act open by direct call: LOW."
---

## Summary

BUSD implementation: betaDelegatedTransfer moves tokens from whoever signed. A holder with code can call transfer itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: delegated transfer: whoever signed is the holder that pays; a holder can call transfer itself. Read from source.
- BUSDImplementation.sol:227 transfer by msg.sender; :523-570 betaDelegatedTransfer recovers _from
- transfer 0xa9059cbb in runtime code at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $70,017 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 68,763 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The holder calls transfer directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
