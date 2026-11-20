---
id: d9439f8e-signed-shortcut-lost
title: "0xd9439f8e (tagged deployed by Prospective LLC: Deployer): signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xd9439f8ef8ec20f3aec8f6203e91d572673bcfd8"
  family: "f2addb4300ffaf81da7cc889bb12bd48"
  copies: 15
  label: "deployed by Prospective LLC: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 9925
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2566
  last_active: 2026-11-18
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
  note: "Permit has a direct twin (EIP-2612 standard); read from the selectors only. Value $9925, txs_90d 2566 (not rating inputs)."
---

## Summary

deployed by Prospective LLC: Deployer (unverified ERC-20): permit fails for a holder whose address has code; the holder still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use permit; it can still call approve itself: a way of signing is lost, no right. Rule: permit-like.
- bytecode at block: approve 0x095ea7b3, permit 0xd505accf and transfer 0xa9059cbb selectors present; no ERC-1271 selector

## Impact and exposure

- Value held at block 26,438,999: $9,925 (ETH and 49 priced tokens, over 15 addresses).
- Activity: 2,566 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
