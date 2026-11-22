---
id: ambire-d7974ab5-rotate-signer-before-migrating
title: "AmbireAccount7702: signer key to rotate before its account takes code"
project: ambire
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: none
contracts:
- address: "0xd7974ab51ea966aee19fb8b6ebab8c22074e16c0"
  family: "a8dadc5a689089c3da1b5dcf9f99e9f5"
  copies: 282
  name: "AmbireAccount7702"
  upgradeable: "no"
  rating: LOW
  value_usd: 1683474
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3481
  last_active: 2026-11-18
  recoveries_14d: 140
fix:
  layer: onchain-config
  who_acts: "the account"
evidence:
  level: source-read
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
  note: "LOW."
---

## Summary

AmbireAccount7702 (279 delegated EOAs). The own key is exempt; other keys need privileges set by the account.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Ambire account (7702, variant) execute: as above / Ambire account ERC-1271: the recovered key must hold a privilege / Ambire account (7702, variant) validateUserOp: the recovered key must hold a…. Read from source.
- reading a8dadc5a: the recovered key must hold a privilege; the account's own key is unaffected
- privileges are set by the account itself

## Impact and exposure

- Value held at block 26,438,999: $1.7M (ETH and 49 priced tokens, over 282 addresses).
- Activity: 3,481 transactions called it in the 90 days before that block; last on 2026-11-18.
- 140 signature recoveries in the study's two-week trace window.

## Remediation

The account re-privileges a new key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
