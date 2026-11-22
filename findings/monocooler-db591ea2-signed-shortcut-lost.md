---
id: monocooler-db591ea2-signed-shortcut-lost
title: "MonoCooler: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xdb591ea2e5db886da872654d58f6cc584b68e7cc"
  family: "777c910b56c8f11d3ed86f0aa817c1ec"
  name: "MonoCooler"
  upgradeable: "no"
  rating: LOW
  txs_90d: 4489
  last_active: 2026-11-18
  recoveries_14d: 12
fix:
  layer: none
  who_acts: "the affected holder (calls the direct function itself)"
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
  note: "Direct setAuthorization open to the same account."
---

## Summary

Olympus MonoCooler: setAuthorizationWithSig fails for an account whose address has code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here / OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call /…. Read from source.
- src/policies/cooler/MonoCooler.sol:229 setAuthorization(authorized,deadline) callable by the account directly
- MonoCooler.sol:235 setAuthorizationWithSig is the signed variant

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 4,489 transactions called it in the 90 days before that block; last on 2026-11-18.
- 12 signature recoveries in the study's two-week trace window.

## Remediation

Account calls setAuthorization itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
