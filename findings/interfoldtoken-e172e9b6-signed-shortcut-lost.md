---
id: interfoldtoken-e172e9b6-signed-shortcut-lost
title: "InterfoldToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xe172e9b6cfbeeb5593bdce3f077356fdb33af904"
  family: "def58d28f39593b0057c18e7738b3745"
  name: "InterfoldToken"
  label: "Interfold: FOLD Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 12632
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 147466
  last_active: 2026-11-18
  recoveries_14d: 56
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
  note: "Direct twins exist (standard EIP-2612 / Compound-style delegation). Value $12632, txs_90d 147466 (not rating inputs)."
---

## Summary

InterfoldToken: permit/delegateBySig-style signed shortcuts (ECDSA must equal the named owner/delegator). A holder with code still calls approve and delegate itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: delegateBySig (OZ 5 Votes): whoever signed is the account that delegates / OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source. Executed: a real transaction reverts with code at the signer.
- source (def58d28f39593b0057c18e7738b3745): signed functions [delegateBySig,permit]; direct approve and delegate(address) present
- no ERC-1271 fallback in the signed path

## Impact and exposure

- Value held at block 26,438,999: $12,632 (ETH and 49 priced tokens).
- Activity: 147,466 transactions called it in the 90 days before that block; last on 2026-11-18.
- 56 signature recoveries in the study's two-week trace window.

## Remediation

Call approve / delegate directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
