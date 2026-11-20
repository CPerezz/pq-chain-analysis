---
id: c22c479a-rotate-signer-before-migrating
title: "0xc22c479a: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc22c479a54925608cc8cd60fbf69510df31aef26"
  family: "bc362389e03a5a3e193d4847eb2f9f5c"
  copies: 4
  upgradeable: "yes"
  rating: LOW
  value_usd: 15158
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 858
  last_active: 2026-11-18
  recoveries_14d: 58
fix:
  layer: onchain-config
  who_acts: "owner (EOA 0x1d75e498…)"
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
  note: "Setter with a live EOA owner."
---

## Summary

No-source upgradeable contract (impl 0x89b268b9…) whose signed path recovers a single stored authority.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setAuthority). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- heimdall decompile of the impl: setAuthority(address) requires msg.sender == owner (OwnableUnauthorizedAccount 0x118cdaa7), emits AuthorityRotated
- owner() 0x1d75e498…: EOA, nonce 291; paused() = false

## Impact and exposure

- Value held at block 26,438,999: $15,158 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 858 transactions called it in the 90 days before that block; last on 2026-11-18.
- 58 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls setAuthority with a fresh EOA (or upgrades).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
