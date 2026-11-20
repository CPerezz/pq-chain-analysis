---
id: cellar-bfc413ea-signed-shortcut-lost
title: "Cellar: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xbfc413ea6cb68c05deda0d9aa7daf8e51a7dddff"
  family: "1da9745c6867eee5e8236dd50428dd87"
  copies: 10
  name: "Cellar"
  label: "deployed by Somm Finance: Deployer 2"
  upgradeable: "no"
  rating: LOW
  value_usd: 12271
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5
  last_active: 2026-11-05
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
  note: "Permit has a direct twin. Value $12271, txs_90d 5 (not rating inputs)."
---

## Summary

Cellar: EIP-2612-style permit (ECDSA must equal the named owner). A holder whose address has code can't use permit, but still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- source (1da9745c6867eee5e8236dd50428dd87): signed functions [permit]; standard approve present
- no ERC-1271 fallback in permit

## Impact and exposure

- Value held at block 26,438,999: $12,271 (ETH and 49 priced tokens, over 10 addresses).
- Activity: 5 transactions called it in the 90 days before that block; last on 2026-11-05.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
