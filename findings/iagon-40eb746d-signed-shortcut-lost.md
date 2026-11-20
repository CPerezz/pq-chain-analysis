---
id: iagon-40eb746d-signed-shortcut-lost
title: "IAGON: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x40eb746dee876ac1e78697b7ca85142d178a1fc8"
  family: "3e95a9c91dec1e70a716f2491bf7eb9e"
  name: "IAGON"
  label: "IAGON: IAG Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 9925
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 18
  last_active: 2026-11-02
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
  note: "Permit has a direct twin. Value $9925, txs_90d 18 (not rating inputs)."
---

## Summary

IAGON: EIP-2612-style permit (ECDSA must equal the named owner). A holder whose address has code can't use permit, but still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- source (3e95a9c91dec1e70a716f2491bf7eb9e): signed functions [permit]; standard approve present
- no ERC-1271 fallback in permit

## Impact and exposure

- Value held at block 26,438,999: $9,925 (ETH and 49 priced tokens).
- Activity: 18 transactions called it in the 90 days before that block; last on 2026-11-02.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
