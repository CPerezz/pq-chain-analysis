---
id: hermez-a68d85df-signed-shortcut-lost
title: "Hermez: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xa68d85df56e733a06443306a095646317b5fa633"
  family: "0c12e3d4bcd895323c6df774e191c46c"
  copies: 2
  name: "Hermez"
  label: "Polygon: Hermez"
  upgradeable: "yes"
  rating: LOW
  value_usd: 83371
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-09-22
fix:
  layer: none
  who_acts: "the user"
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
  note: "Account creation stays open by direct call: LOW."
---

## Summary

Hermez rollup (upgradeable): _checkSig lets a coordinator create an L2 account for an Ethereum address that signed. An address with code can still create its account and deposit by its own L1 transaction.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Hermez _checkSig: whoever signed authorises a rollup key for its own address when the coordinator creates the account; an account can also be created by its own L1 transaction. Read from source.
- Hermez.sol:395 addL1Transaction (direct, msg.sender is the account's Ethereum address)
- HermezHelpers.sol:263-300 _checkSig recovers only for coordinator-created accounts

## Impact and exposure

- Value held at block 26,438,999: $83,371 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-09-22.

## Remediation

The user creates the account with addL1Transaction.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
