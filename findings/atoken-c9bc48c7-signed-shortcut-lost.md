---
id: atoken-c9bc48c7-signed-shortcut-lost
title: "AToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xc9bc48c72154ef3e5425641a3c747242112a46af"
  family: "6bb3c66db38148e3b3cc414472a7da01"
  copies: 4
  name: "AToken"
  label: "Aave: aRAI Token V2"
  upgradeable: "yes"
  rating: LOW
  value_usd: 7734164
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 266
  last_active: 2026-11-18
fix:
  layer: account-migration
  who_acts: "the token holder"
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
  note: "Standard signed shortcut; same act open by direct call → LOW."
---

## Summary

AToken (Aave: aRAI Token V2): a signed shortcut (permit/authorization) requires the recovered address to equal the named owner; EIP-8151 makes it fail for an owner whose address holds non-delegation code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Aave v2 aToken permit: the owner named must have signed. Read from source.
- the dossier source has the standard approve (and transfer) the holder calls directly
- code at block has approve selector 0x095ea7b3 or source defines approve; no signature needed
- study note: Aave v2 aToken permit: the owner named must have signed. Read from source.

## Impact and exposure

- Value held at block 26,438,999: $7.7M (ETH and 49 priced tokens, over 4 addresses).
- Activity: 266 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Holder calls approve (or the direct function) itself instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
