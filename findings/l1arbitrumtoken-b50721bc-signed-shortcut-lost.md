---
id: l1arbitrumtoken-b50721bc-signed-shortcut-lost
title: "L1ArbitrumToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb50721bcf8d664c30412cfbc6cf7a15145234ad1"
  family: "0b070f2c25f2ca7c26c2e937e20baf6c"
  copies: 2
  name: "L1ArbitrumToken"
  label: "Arbitrum Foundation: ARB Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 5233
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 65475
  last_active: 2026-11-18
  recoveries_14d: 8
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
  note: "Permit has a direct twin. Value $5233, txs_90d 65475 (not rating inputs)."
---

## Summary

L1ArbitrumToken: EIP-2612-style permit (ECDSA must equal the named owner). A holder whose address has code can't use permit, but still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 upgradeable permit. Read from source. Executed: a real transaction reverts with code at the signer.
- source (0b070f2c25f2ca7c26c2e937e20baf6c): signed functions [permit]; standard approve present
- no ERC-1271 fallback in permit

## Impact and exposure

- Value held at block 26,438,999: $5,233 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 65,475 transactions called it in the 90 days before that block; last on 2026-11-18.
- 8 signature recoveries in the study's two-week trace window.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
