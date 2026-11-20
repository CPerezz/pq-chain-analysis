---
id: atoken-9ff58f4f-signed-shortcut-lost
title: "AToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x9ff58f4ffb29fa2266ab25e75e2a8b3503311656"
  family: "5b054961ae57346623f35769b778f4cd"
  copies: 3
  name: "AToken"
  label: "Aave: aWBTC Token V2"
  upgradeable: "yes"
  rating: LOW
  value_usd: 18684234
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 328
  last_active: 2026-11-16
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

AToken (Aave: aWBTC Token V2): a signed shortcut (permit/authorization) requires the recovered address to equal the named owner; EIP-8151 makes it fail for an owner whose address holds non-delegation code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Aave v2 aToken permit: the owner named must have signed. Read from source.
- the dossier source has the standard approve (and transfer) the holder calls directly
- code at block has approve selector 0x095ea7b3 or source defines approve; no signature needed
- study note: Aave v2 aToken permit: the owner named must have signed. Read from source.

## Impact and exposure

- Value held at block 26,438,999: $18.7M (ETH and 49 priced tokens, over 3 addresses).
- Activity: 328 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

Holder calls approve (or the direct function) itself instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
