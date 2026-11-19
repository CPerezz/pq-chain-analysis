---
id: archetype-47c6ac05-fixed-signer
title: "ArchetypeLogic: signer fixed in code"
project: archetype
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x47c6ac05cf695748e02a7a2685a0b3801dceb57a"
  family: "95ca9b27856c62f78d3b5ebf3c50bc60"
  copies: 621
  name: "ArchetypeLogic"
  upgradeable: "no"
  rating: LOW
  value_usd: 21205
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 8041
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "collections mint without affiliate signatures"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "auxiliary path only"
---

## Summary

`ArchetypeLogic` at `0x47c6ac05cf695748e02a7a2685a0b3801dceb57a`, with 620 more collections. The fixed signer only authorises affiliate fees; minting without an affiliate stays open.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Archetype (older): affiliate signer of the collection's fixed configuration; it only decides affiliate fees. Read by hand.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Read by hand: the affiliate signer is part of each collection's fixed configuration and is only checked when a mint names an affiliate.
- The 621 addresses are fixed delegates; no upgrade.
- 8,041 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $21,205 (ETH and 49 priced tokens, over 621 addresses).
- Activity: 8,041 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

None needed: affiliate mints stop, plain mints go on.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
