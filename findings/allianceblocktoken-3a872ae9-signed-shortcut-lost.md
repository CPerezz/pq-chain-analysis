---
id: allianceblocktoken-3a872ae9-signed-shortcut-lost
title: "AllianceBlockToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x3a872ae95f645acdd17db8aa961f4d39e0f5bc39"
  family: "0aca48a9f2b28ba3fa641834a61d76c0"
  copies: 4
  name: "AllianceBlockToken"
  label: "Nexera Foundation: NXRA Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 2887
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4940
  last_active: 2026-11-18
  recoveries_14d: 2
fix:
  layer: offchain
  who_acts: "the affected holder (signer with code)"
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
  note: "Permit has a direct twin. Value $2887, txs_90d 4940 (not rating inputs)."
---

## Summary

AllianceBlockToken: EIP-2612-style permit (ECDSA must equal the named owner). A holder whose address has code can't use permit, but still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 upgradeable permit. Read from source. Executed: a real transaction loses its effect with code at the signer.
- source (0aca48a9f2b28ba3fa641834a61d76c0): signed functions [permit]; standard approve present
- no ERC-1271 fallback in permit

## Impact and exposure

- Value held at block 26,438,999: $2,887 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 4,940 transactions called it in the 90 days before that block; last on 2026-11-18.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
