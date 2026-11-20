---
id: asteth-bd233d4f-signed-shortcut-lost
title: "AStETH: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xbd233d4ffdaa9b7d1d3e6b18cccb8d091142893a"
  family: "efc117127a7f5580a43aaca0bcd523a3"
  copies: 2
  name: "AStETH"
  label: "Lido: Aave interest bearing STETH Imp"
  upgradeable: "no"
  rating: LOW
  value_usd: 3731108
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1109
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

AStETH (Lido: Aave interest bearing STETH Imp): a signed shortcut (permit/authorization) requires the recovered address to equal the named owner; EIP-8151 makes it fail for an owner whose address holds non-delegation code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Aave v2 aToken permit: the owner named must have signed. Read from source.
- the dossier source has the standard approve (and transfer) the holder calls directly
- code at block has approve selector 0x095ea7b3 or source defines approve; no signature needed
- study note: Aave v2 aToken permit: the owner named must have signed. Read from source.

## Impact and exposure

- Value held at block 26,438,999: $3.7M (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,109 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Holder calls approve (or the direct function) itself instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
