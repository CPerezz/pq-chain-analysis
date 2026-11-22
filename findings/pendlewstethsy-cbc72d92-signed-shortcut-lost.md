---
id: pendlewstethsy-cbc72d92-signed-shortcut-lost
title: "PendleWstEthSY: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xcbc72d92b2dc8187414f6734718563898740c0bc"
  family: "1881a5d8d4b89e3af2a722c304421239"
  name: "PendleWstEthSY"
  label: "Pendle: SY-stETH Token 2"
  upgradeable: "no"
  rating: LOW
  value_usd: 6062058
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 407
  last_active: 2026-11-17
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

PendleWstEthSY (Pendle: SY-stETH Token 2): a signed shortcut (permit/authorization) requires the recovered address to equal the named owner; EIP-8151 makes it fail for an owner whose address holds non-delegation code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call. Read from source.
- the dossier source has the standard approve (and transfer) the holder calls directly
- code at block has approve selector 0x095ea7b3 or source defines approve; no signature needed
- study note: OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call. Read from source.

## Impact and exposure

- Value held at block 26,438,999: $6.1M (ETH and 49 priced tokens).
- Activity: 407 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Holder calls approve (or the direct function) itself instead of signing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
