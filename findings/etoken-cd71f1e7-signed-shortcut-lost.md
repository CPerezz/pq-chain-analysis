---
id: etoken-cd71f1e7-signed-shortcut-lost
title: "EToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xcd71f1e7e01926cc0c3f5257f3b49a73844d48bf"
  family: "8889fd3346d86c80cefd8edcda7bb808"
  copies: 12
  name: "EToken"
  label: "Ensuro: eUSDSr Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 10286
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1525
  last_active: 2026-11-18
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
  note: "Permit has a direct twin. Value $10286, txs_90d 1525 (not rating inputs)."
---

## Summary

EToken: EIP-2612-style permit (ECDSA must equal the named owner). A holder whose address has code can't use permit, but still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- source (8889fd3346d86c80cefd8edcda7bb808): signed functions [_checkProxy,permit]; standard approve present
- no ERC-1271 fallback in permit

## Impact and exposure

- Value held at block 26,438,999: $10,286 (ETH and 49 priced tokens, over 12 addresses).
- Activity: 1,525 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
