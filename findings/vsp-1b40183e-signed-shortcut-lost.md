---
id: vsp-1b40183e-signed-shortcut-lost
title: "VSP: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x1b40183efb4dd766f11bda7a7c3ad8982e998421"
  family: "ee89f4728fed1e02e4aad5a378b6991b"
  name: "VSP"
  label: "Vesper Finance: Vesper Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 12091
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 908
  last_active: 2026-11-17
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
  note: "Direct twins exist (standard EIP-2612 / Compound-style delegation). Value $12091, txs_90d 908 (not rating inputs)."
---

## Summary

VSP: permit/delegateBySig-style signed shortcuts (ECDSA must equal the named owner/delegator). A holder with code still calls approve and delegate itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: VSP delegateBySig: whoever signed delegates / VSP permit: the owner named must have signed. Read from source.
- source (ee89f4728fed1e02e4aad5a378b6991b): signed functions [delegateBySig,permit]; direct approve and delegate(address) present
- no ERC-1271 fallback in the signed path

## Impact and exposure

- Value held at block 26,438,999: $12,091 (ETH and 49 priced tokens).
- Activity: 908 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Call approve / delegate directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
