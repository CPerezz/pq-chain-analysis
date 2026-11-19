---
id: archetype-13b58991-fixed-signer
title: "ArchetypeLogic: signer fixed in code"
project: archetype
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x13b58991ded462090229427ecbbb7e7f99571a6d"
  family: "bcb4c5f061f4582d0d632cf0b1680782"
  copies: 346
  name: "ArchetypeLogic"
  upgradeable: "no"
  rating: LOW
  value_usd: 20701
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4792
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

`ArchetypeLogic` at `0x13b58991ded462090229427ecbbb7e7f99571a6d`, with 345 more collections. As the other Archetype version: the fixed signer only authorises affiliate fees.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Archetype (older): as above. Read by hand.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Read by hand (same design).
- Fixed delegates; no upgrade.
- 4,792 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $20,701 (ETH and 49 priced tokens, over 346 addresses).
- Activity: 4,792 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
