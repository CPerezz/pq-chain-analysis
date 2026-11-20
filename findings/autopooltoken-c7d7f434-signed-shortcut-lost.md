---
id: autopooltoken-c7d7f434-signed-shortcut-lost
title: "AutopoolToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xc7d7f434c015f2a7e77df9763ade300f2171a05a"
  family: "3f158592eb16e81589cbbc13332710dd"
  copies: 30
  name: "AutopoolToken"
  label: "Tokemak: autoUSD Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 4331
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2049
  last_active: 2026-11-18
  recoveries_14d: 15
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
  note: "Permit has a direct twin. Value $4331, txs_90d 2049 (not rating inputs)."
---

## Summary

AutopoolToken: EIP-2612-style permit (ECDSA must equal the named owner). A holder whose address has code can't use permit, but still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Tokemak AutopoolToken permit: ECDSA.recover must equal the owner named in the call. Read from source.
- source (3f158592eb16e81589cbbc13332710dd): signed functions [permit]; standard approve present
- no ERC-1271 fallback in permit

## Impact and exposure

- Value held at block 26,438,999: $4,331 (ETH and 49 priced tokens, over 30 addresses).
- Activity: 2,049 transactions called it in the 90 days before that block; last on 2026-11-18.
- 15 signature recoveries in the study's two-week trace window.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
