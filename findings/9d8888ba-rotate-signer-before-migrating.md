---
id: 9d8888ba-rotate-signer-before-migrating
title: "0x9d8888ba: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9d8888ba6c653f315606bfb494eb679fd02000cb"
  family: "59850547334da976b227ab94063d3718"
  copies: 2
  upgradeable: "no"
  rating: LOW
  txs_90d: 5887
  last_active: 2026-11-18
  recoveries_14d: 122
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x323e…0806"
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

Unverified contract: tickets signed by the stored ticketSigner.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: tickets signed by a stored ticketSigner; the owner replaces it (setTicketSigner); the replay with code at the signer reverts, as expected for a stored key. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- setTicketSigner(address): eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0x323ea17b… EOA, nonce 72

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 5,887 transactions called it in the 90 days before that block; last on 2026-11-18.
- 122 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls setTicketSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
