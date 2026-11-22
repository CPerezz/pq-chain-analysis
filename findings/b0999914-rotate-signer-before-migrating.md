---
id: b0999914-rotate-signer-before-migrating
title: "0xb0999914: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb0999914b3de1be58ef2416af09bd2e7f8aad03c"
  family: "2f07018c59c2fd85ee59db02ecfbe56a"
  copies: 2
  upgradeable: "no"
  rating: LOW
  txs_90d: 87517
  last_active: 2026-11-18
  recoveries_14d: 3169
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x3351…1465"
evidence:
  level: executed
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
  verdict: confirmed
  rating: LOW
  note: "setter callable by a live EOA."
---

## Summary

Unverified contract whose signer is an operator set; an operator with code fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setOperator). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- setOperator(address,bool): eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0x33515713… EOA, nonce 16

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 87,517 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3,169 signature recoveries in the study's two-week trace window.

## Remediation

Owner swaps operators via setOperator.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
