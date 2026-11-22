---
id: vyper-contract-bcbb5b54-signed-shortcut-lost
title: "Vyper_contract: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xbcbb5b54fa51e7b7dc920340043b203447842a6b"
  family: "b684c81ee5c9112259a0f55bf46a718d"
  copies: 91
  name: "Vyper_contract"
  label: "Yearn: yvCurve-EURTUSD Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 9384
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2073
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
  note: "Permit has a direct twin. Value $9384, txs_90d 2073 (not rating inputs)."
---

## Summary

Vyper_contract: EIP-2612-style permit (ECDSA must equal the named owner). A holder whose address has code can't use permit, but still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Vyper permit with a packed signature: ecrecover must equal the owner. Read from source.
- source (b684c81ee5c9112259a0f55bf46a718d): signed functions [permit]; standard approve present
- no ERC-1271 fallback in permit

## Impact and exposure

- Value held at block 26,438,999: $9,384 (ETH and 49 priced tokens, over 91 addresses).
- Activity: 2,073 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
