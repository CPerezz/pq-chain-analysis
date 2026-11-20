---
id: cult-b12ca3db-signed-shortcut-lost
title: "Cult: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb12ca3dbf866da26b0f55a20a51fea8efd8592f9"
  family: "704e4aefb171a5ead2791a9a83723733"
  copies: 2
  name: "Cult"
  label: "Cult DAO: CULT Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 11549
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2562
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
  note: "Direct twins exist (standard EIP-2612 / Compound-style delegation). Value $11549, txs_90d 2562 (not rating inputs)."
---

## Summary

Cult: permit/delegateBySig-style signed shortcuts (ECDSA must equal the named owner/delegator). A holder with code still calls approve and delegate itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: delegateBySig: whoever signed is the delegator; a holder can call delegate itself / OpenZeppelin 4 upgradeable permit. Read from source.
- source (704e4aefb171a5ead2791a9a83723733): signed functions [delegateBySig,permit]; direct approve and delegate(address) present
- no ERC-1271 fallback in the signed path

## Impact and exposure

- Value held at block 26,438,999: $11,549 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,562 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Call approve / delegate directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
