---
id: bitdao-1a4b4669-signed-shortcut-lost
title: "BitDAO: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x1a4b46696b2bb4794eb3d4c26f1c55f9170fa4c5"
  family: "41464a6f868a77d20702dcda35498a0f"
  name: "BitDAO"
  upgradeable: "no"
  rating: LOW
  value_usd: 5
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2181
  last_active: 2026-11-18
fix:
  layer: offchain
  who_acts: "token holder (calls delegate itself)"
evidence:
  level: bytecode
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
  note: "signed shortcut lost, delegate stays open to the same holder → LOW."
---

## Summary

BitDAO: delegateBySig needs the holder's ECDSA signature; under EIP-8151 a holder whose address has code can no longer use it, but keeps delegate.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use delegateBySig; it can still call delegate itself: a way of signing is lost, no right. Rule: permit-like.
- bytecode at block 26438999 (proxy + implementation) holds direct selectors approve 0x095ea7b3, transfer 0xa9059cbb, delegate 0x5c19a95c

## Impact and exposure

- Value held at block 26,438,999: $5 (ETH and 49 priced tokens).
- Activity: 2,181 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

holder calls delegate directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
