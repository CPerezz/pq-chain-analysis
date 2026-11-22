---
id: 7f060652-rotate-signer-before-migrating
title: "0x7f060652: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7f06065230a58f6d2e53a01ef77c114f711b0756"
  family: "6c67d648ce60ff6c8c77ddcf3b17afd0"
  copies: 2
  upgradeable: "no"
  rating: LOW
  txs_90d: 11646
  last_active: 2026-10-20
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x5e99…43f6"
evidence:
  level: bytecode
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

Unverified contract with a stored signer (contract is paused at the block: paused()=1).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setPriceFeed, setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- setSigner(address): eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0x5e9947da… EOA, nonce 92; signer() = 0x62380c65…

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 11,646 transactions called it in the 90 days before that block; last on 2026-10-20.

## Remediation

Owner calls setSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
