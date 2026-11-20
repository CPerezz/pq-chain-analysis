---
id: cpool-66761fa4-signed-shortcut-lost
title: "CPOOL: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x66761fa41377003622aee3c7675fc7b5c1c2fac5"
  family: "ca773e578a53121600fd2b99aa4e60c1"
  name: "CPOOL"
  label: "Clearpool: CPOOL Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 10827
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 72438
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
  note: "Direct twins exist (standard EIP-2612 / Compound-style delegation). Value $10827, txs_90d 72438 (not rating inputs)."
---

## Summary

CPOOL: permit/delegateBySig-style signed shortcuts (ECDSA must equal the named owner/delegator). A holder with code still calls approve and delegate itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: CPOOL delegateBySig. Read from source.
- source (ca773e578a53121600fd2b99aa4e60c1): signed functions [delegateBySig]; direct approve and delegate(address) present
- no ERC-1271 fallback in the signed path

## Impact and exposure

- Value held at block 26,438,999: $10,827 (ETH and 49 priced tokens).
- Activity: 72,438 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Call approve / delegate directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
