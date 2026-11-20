---
id: tranche-c58d0444-signed-shortcut-lost
title: "Tranche: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xc58d044404d8b14e953c115e67823784dea53d8f"
  family: "909bdaa54ecc214594f762430af68ce6"
  copies: 4
  name: "Tranche"
  label: "Strata: jrUSDe Token"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 8129
  last_active: 2026-11-18
  recoveries_14d: 4
fix:
  layer: none
  who_acts: "the affected holder (calls the direct function itself)"
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
  note: "Standard signed shortcut; approve remain open to the same holder."
---

## Summary

Tranche: permit stops working for a holder whose address has code; the act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- bytecode (proxy+implementation 0xe91869f96806b480dd61d57e17919068d35ac09c) exposes approve(address,uint256) 0x095ea7b3 and transfer 0xa9059cbb
- study note: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 8,129 transactions called it in the 90 days before that block; last on 2026-11-18.
- 4 signature recoveries in the study's two-week trace window.

## Remediation

Holder calls approve itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
