---
id: roles-b6b4f1f5-rotate-signer-before-migrating
title: "Roles: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb6b4f1f56361636c76f9701a9bb5b624e26234d8"
  family: "dd7c4d9249947555255745b4cfb7e887"
  copies: 357
  name: "Roles"
  upgradeable: "no"
  rating: LOW
  txs_90d: 13319
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "owner Safe 0xce93c2ab…"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "setter held by a live Safe."
---

## Summary

Zodiac Roles modifier: an enabled module may sign instead of calling; a module key with code fails the signed path.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Zodiac Roles modifier by its function names. Bytecode and names.
- enableModule(address): eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0xce93c2ab…, a 2-of-3 Safe

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 357 addresses).
- Activity: 13,319 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Owner enables a new module key / disables the old.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
