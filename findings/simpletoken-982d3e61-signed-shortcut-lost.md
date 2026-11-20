---
id: simpletoken-982d3e61-signed-shortcut-lost
title: "SimpleToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x982d3e614ae33c92016d019ad3d9cd61b5aba7a8"
  family: "6f8c4544b7a68e348bd520df74d84e1a"
  copies: 8
  name: "SimpleToken"
  label: "Resolv USR: USR Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 3429
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2718
  last_active: 2026-11-17
  recoveries_14d: 3
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
  note: "Permit has a direct twin. Value $3429, txs_90d 2718 (not rating inputs)."
---

## Summary

SimpleToken: EIP-2612-style permit (ECDSA must equal the named owner). A holder whose address has code can't use permit, but still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source. Executed: a real transaction reverts with code at the signer.
- source (6f8c4544b7a68e348bd520df74d84e1a): signed functions [permit]; standard approve present
- no ERC-1271 fallback in permit

## Impact and exposure

- Value held at block 26,438,999: $3,429 (ETH and 49 priced tokens, over 8 addresses).
- Activity: 2,718 transactions called it in the 90 days before that block; last on 2026-11-17.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
