---
id: 046eee2c-signed-shortcut-lost
title: "0x046eee2c (tagged Rollbit: RLB Token): signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x046eee2cc3188071c02bfc1745a6b17c656e3f3d"
  family: "7591fc212c628c044f9873bc0c4eb0a3"
  copies: 2
  label: "Rollbit: RLB Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 11188
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 20730
  last_active: 2026-11-18
  recoveries_14d: 6
fix:
  layer: offchain
  who_acts: "the affected holder (signer with code)"
evidence:
  level: executed
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
  note: "Permit has a direct twin (EIP-2612 standard); read from the selectors only. Value $11188, txs_90d 20730 (not rating inputs)."
---

## Summary

Rollbit: RLB Token (unverified ERC-20): permit fails for a holder whose address has code; the holder still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use permit; it can still call approve itself: a way of signing is lost, no right. Rule: permit-like. Executed: a real transaction reverts with code at the signer.
- bytecode at block: approve 0x095ea7b3, permit 0xd505accf and transfer 0xa9059cbb selectors present; no ERC-1271 selector

## Impact and exposure

- Value held at block 26,438,999: $11,188 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 20,730 transactions called it in the 90 days before that block; last on 2026-11-18.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
