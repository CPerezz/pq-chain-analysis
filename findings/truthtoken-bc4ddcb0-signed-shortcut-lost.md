---
id: truthtoken-bc4ddcb0-signed-shortcut-lost
title: "TruthToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xbc4ddcb0f6f0ee0f18a1588ffa4c8493d2fc84c7"
  family: "44885d32bac70e87b2148d85cf7e7226"
  copies: 6
  name: "TruthToken"
  label: "Truth: Old TRUU Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 1669
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 9414
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
  note: "Permit has a direct twin (EIP-2612). The code was read at latest, which is allowed because with the owner renounced it can't change. Value $1669, txs_90d 9414 (not rating inputs)."
---

## Summary

Truth: Old TRUU token (unverified UUPS ERC-20 holding its own code): permit fails for a holder whose address has code; the holder still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use permit; it can still call approve itself: a way of signing is lost, no right. Rule: permit-like.
- code at latest, block ~26452924 (publicnode): approve 0x095ea7b3, permit 0xd505accf, transfer 0xa9059cbb present, no ERC-1271 0x1626ba7e; 10,365 bytes, the same as facts code_bytes at 26438999
- review/facts.jsonl: owner() = 0 at block 26438999 and upgrades are owner-gated (upgradeToAndCall), so the code cannot have changed since

## Impact and exposure

- Value held at block 26,438,999: $1,669 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 9,414 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
