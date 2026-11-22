---
id: usdnprotocolactionsutilslibrary-d4e615ab-signed-shortcut-lost
title: "UsdnProtocolActionsUtilsLibrary: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xd4e615ab327324e9f2bb492c42d47ee8213959c0"
  family: "d94e2eda834e0b493a2e328b2108bc9f"
  copies: 9
  name: "UsdnProtocolActionsUtilsLibrary"
  label: "SmarDex: USDN Protocol"
  upgradeable: "no"
  rating: LOW
  value_usd: 1027156
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 319
  last_active: 2026-11-15
  recoveries_14d: 5
fix:
  layer: account-migration
  who_acts: "the position owner"
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
  note: "Same acts open by direct call → LOW."
---

## Summary

USDN protocol library: close and ownership transfer by an EIP-712 delegation of the position owner; an owner with code loses delegations.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: USDN close delegation: the position owner must have signed for this caller; the delegation is optional, the owner can call itself (that branch read by name only) / USDN transfer of position ownership…. Read from source.
- UsdnProtocolActionsUtilsLibrary.sol:452 if (msg.sender != pos.user) — the owner closing directly reads no signature
- …:98 if (msg.sender != oldOwner) — direct ownership transfer reads no signature

## Impact and exposure

- Value held at block 26,438,999: $1.0M (ETH and 49 priced tokens, over 9 addresses).
- Activity: 319 transactions called it in the 90 days before that block; last on 2026-11-15.
- 5 signature recoveries in the study's two-week trace window.

## Remediation

Position owner acts directly as msg.sender.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
