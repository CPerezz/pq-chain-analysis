---
id: vyper-contract-b6246cb8-signed-shortcut-lost
title: "Vyper_contract: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb6246cb8c98a59a753a94c8e16ac54eadb392e40"
  family: "0db621e8a3a3ab558476948adecfeedf"
  copies: 258
  name: "Vyper_contract"
  label: "Yearn: yvCurve-ynETH-B-f Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3019
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
  note: "Permit has a direct twin. Value $2346, txs_90d 3019 (not rating inputs)."
---

## Summary

Vyper_contract: EIP-2612-style permit (ECDSA must equal the named owner). A holder whose address has code can't use permit, but still calls approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Vyper permit with a packed signature (variant). Read from source.
- source (0db621e8a3a3ab558476948adecfeedf): signed functions [permit]; standard approve present
- no ERC-1271 fallback in permit

## Impact and exposure

- Value held at block 26,438,999: $2,346 (ETH and 49 priced tokens, over 258 addresses).
- Activity: 3,019 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
