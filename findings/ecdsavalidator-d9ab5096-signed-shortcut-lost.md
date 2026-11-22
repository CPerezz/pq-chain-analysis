---
id: ecdsavalidator-d9ab5096-signed-shortcut-lost
title: "ECDSAValidator: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xd9ab5096a832b9ce79914329daee236f8eea0390"
  family: "af33ec96c5b49f11ad5d7294beb2f5a9"
  copies: 3
  name: "ECDSAValidator"
  upgradeable: "no"
  rating: LOW
  txs_90d: 12702
  last_active: 2026-11-18
  recoveries_14d: 3517
fix:
  layer: none
  who_acts: "the affected signer, by calling directly"
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
  note: "LOW: owner rotation per account and the direct-call path remain."
---

## Summary

Kernel v2 ECDSAValidator: the owner recorded per account must sign user operations by ECDSA.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Kernel v2 ECDSA validator (source read): the owner recorded for the calling account must sign; the account can set another owner (enable), and the owner may also call the account itself (validCaller). Read by hand. Executed: a real transaction reverts with code at the signer.
- source (solady ECDSA.recover) checks the stored owner for the calling Kernel account
- the account can enable another owner (enable) and the owner may call the account directly (validCaller), per the row's hand reading which matches the source

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 12,702 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3,517 signature recoveries in the study's two-week trace window.

## Remediation

affected party uses the direct call

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
