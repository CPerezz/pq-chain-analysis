---
id: f8ec0f87-signed-shortcut-lost
title: "0xf8ec0f87 (tagged Cozy Finance: ETH Money Market): signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xf8ec0f87036565d6b2b19780a54996c3b03e91ea"
  family: "439e9d27964992c8f3e2521171111af2"
  copies: 9
  label: "Cozy Finance: ETH Money Market"
  upgradeable: "no"
  rating: LOW
  value_usd: 39881
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 61
  last_active: 2026-11-14
fix:
  layer: offchain
  who_acts: "the holder"
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $39881, txs_90d 61."
---

## Summary

Cozy Finance: ETH Money Market: token bytecode with a permit; under EIP-8151 a holder whose address has code can no longer use permit.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use permit; it can still call approve itself: a way of signing is lost, no right. Rule: permit-like.
- Cozy Finance: ETH Money Market: bytecode carries both permit selector 0xd505accf and approve selector 0x095ea7b3 (dossier code.hex)
- No verified source; study classed it permit-like by bytecode and names
- approve is called by the holder itself, same party as permit

## Impact and exposure

- Value held at block 26,438,999: $39,881 (ETH and 49 priced tokens, over 9 addresses).
- Activity: 61 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

The holder calls approve itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
