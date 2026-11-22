---
id: 7704ccbf-rotate-signer-before-migrating
title: "0x7704ccbf: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7704ccbfb5e9791a9639bcdfe13366964f4599f2"
  family: "e540bab9745a4dcedc870a78ee42ea5b"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  value_usd: 35
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1034
  last_active: 2026-10-24
fix:
  layer: onchain-config
  who_acts: "owner Safe 0x7393…36ac"
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
  note: "stored-key setter callable by a live Safe"
---

## Summary

UUPS proxy (impl 0x84531266…c502) checking a single stored signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- setSigner(address) and upgradeToAndCall are onlyOwner (error 0x118cdaa7) in impl decompile
- owner() = 0x7393c2ed462ce04d5c923bf7e8953be7d7c736ac at block 26438999: Safe, threshold 2 of 3 owners; signer() = 0x9addbf9f…d82e

## Impact and exposure

- Value held at block 26,438,999: $35 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,034 transactions called it in the 90 days before that block; last on 2026-10-24.

## Remediation

Safe owner calls setSigner with a fresh EOA

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
