---
id: 35910dd7-signed-shortcut-lost
title: "0x35910dd7: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x35910dd7ff9b93ad2f382455bcf99dcb77184c98"
  family: "da93f260a811878a1dad70349d4b6ffe"
  copies: 10
  upgradeable: "no"
  rating: LOW
  value_usd: 27429
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1628
  last_active: 2026-11-18
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $27429, txs_90d 1628."
---

## Summary

unnamed contract: token bytecode with a permit; under EIP-8151 a holder whose address has code can no longer use permit.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use permit; it can still call approve itself: a way of signing is lost, no right. Rule: permit-like.
- unnamed contract: bytecode carries both permit selector 0xd505accf and approve selector 0x095ea7b3 (dossier code.hex)
- No verified source; study classed it permit-like by bytecode and names
- approve is called by the holder itself, same party as permit

## Impact and exposure

- Value held at block 26,438,999: $27,429 (ETH and 49 priced tokens, over 10 addresses).
- Activity: 1,628 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The holder calls approve itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
