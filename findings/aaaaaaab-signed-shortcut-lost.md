---
id: aaaaaaab-signed-shortcut-lost
title: "0xaaaaaaab (tagged Aqua Patina: APETH Token): signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xaaaaaaabc6cbc3a1fd3a0fe0fdec43251c6562f5"
  family: "b32c05878eb34db2b9e80dec1bc4fb04"
  copies: 2
  label: "Aqua Patina: APETH Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 13534
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "the affected holder (signer with code)"
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
  note: "Permit has a direct twin (EIP-2612 standard); read from the selectors only. Value $13534, txs_90d 0 (not rating inputs)."
---

## Summary

Aqua Patina: APETH Token (unverified ERC-20): permit fails for a holder whose address has code; the holder still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use permit; it can still call approve itself: a way of signing is lost, no right. Rule: permit-like.
- bytecode at block: approve 0x095ea7b3, permit 0xd505accf and transfer 0xa9059cbb selectors present; no ERC-1271 selector

## Impact and exposure

- Value held at block 26,438,999: $13,534 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
