---
id: singleownermsca-9512a1ff-rotate-signer-before-migrating
title: "SingleOwnerMSCA: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x9512a1ff49fcceaa464ae44226a004ba19122518"
  family: "d37ca877a212ec63a67b79a01d4300e8"
  copies: 40
  name: "SingleOwnerMSCA"
  label: "Binance 90"
  upgradeable: "yes"
  rating: NONE
  value_usd: 1699569797
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 17
  last_active: 2026-11-10
fix:
  layer: none
  who_acts: "account owner"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Refuted on the same basis as 0xce4385: ERC-1271 for the same signer. Otherwise LOW, owner self-rotation."
---

## Summary

Circle SingleOwnerMSCA variant (40 proxies). The owner is checked by SignatureChecker with an ERC-1271 fall-through on the owner.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Circle single-owner modular account: the owner is checked with SignatureChecker, so an owner with code is asked through ERC-1271; the owner can also call the account itself and hand it over…. Read (same text as a family read).
- reading d37ca877 summary: the code falls through to ERC-1271 on the owner; the owner can call the account and rotate ownership directly
- same SignatureChecker idiom as family ee56db4b

## Impact and exposure

- Value held at block 26,438,999: $1,699.6M (ETH and 49 priced tokens, over 40 addresses).
- Activity: 17 transactions called it in the 90 days before that block; last on 2026-11-10.

## Remediation

The owner implements ERC-1271 or rotates first.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
