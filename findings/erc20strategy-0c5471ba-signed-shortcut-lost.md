---
id: erc20strategy-0c5471ba-signed-shortcut-lost
title: "ERC20Strategy: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x0c5471ba3f7381e4bf0fe232ab1ec5522ffbfdf1"
  family: "fa08de42ec94b054b586b961b664adfb"
  copies: 6
  name: "ERC20Strategy"
  upgradeable: "yes"
  rating: LOW
  value_usd: 11188
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 74
  last_active: 2026-11-07
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
  note: "Permit has a direct twin. Value $11188, txs_90d 74 (not rating inputs)."
---

## Summary

ERC20Strategy: EIP-2612-style permit (ECDSA must equal the named owner). A holder whose address has code can't use permit, but still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Solady ERC20 permit (variant, assembly): the recovered address must be the owner named. Read from source.
- source (fa08de42ec94b054b586b961b664adfb): signed functions [_checkOnlyProxy,execute,permit]; standard approve present
- no ERC-1271 fallback in permit

## Impact and exposure

- Value held at block 26,438,999: $11,188 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 74 transactions called it in the 90 days before that block; last on 2026-11-07.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
