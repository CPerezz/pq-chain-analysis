---
id: nya-79ebc9a2-signed-shortcut-lost
title: "Nya: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x79ebc9a2ce02277a4b5b3a768b1c0a4ed75bd936"
  family: "7f8da489080989772cb2406d204ac480"
  copies: 2
  name: "Nya"
  label: "deployed by Nya: Deployer"
  upgradeable: "yes"
  rating: LOW
  value_usd: 10106
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 315
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
  note: "Direct twins exist (standard EIP-2612 / Compound-style delegation). Value $10106, txs_90d 315 (not rating inputs)."
---

## Summary

Nya: permit/delegateBySig-style signed shortcuts (ECDSA must equal the named owner/delegator). A holder with code still calls approve and delegate itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: delegateBySig (OZ 5 Votes): whoever signed is the account that delegates / OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- source (7f8da489080989772cb2406d204ac480): signed functions [_checkProxy,delegateBySig,permit]; direct approve and delegate(address) present
- no ERC-1271 fallback in the signed path

## Impact and exposure

- Value held at block 26,438,999: $10,106 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 315 transactions called it in the 90 days before that block; last on 2026-11-15.

## Remediation

Call approve / delegate directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
