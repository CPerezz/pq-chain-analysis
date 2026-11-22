---
id: vault-cdde0318-signed-shortcut-lost
title: "Vault: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xcdde0318156506869f8c59fe3d806df0b6f6ab00"
  family: "fea5edee521ea7752efed105548694ed"
  copies: 18
  name: "Vault"
  label: "YieldNest: ynRWAx Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 4692
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2415
  last_active: 2026-11-15
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
  note: "Permit has a direct twin. Value $4692, txs_90d 2415 (not rating inputs)."
---

## Summary

Vault: EIP-2612-style permit (ECDSA must equal the named owner). A holder whose address has code can't use permit, but still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- source (fea5edee521ea7752efed105548694ed): signed functions [execute,executeBatch,permit,signature,signatures]; standard approve present
- no ERC-1271 fallback in permit

## Impact and exposure

- Value held at block 26,438,999: $4,692 (ETH and 49 priced tokens, over 18 addresses).
- Activity: 2,415 transactions called it in the 90 days before that block; last on 2026-11-15.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
