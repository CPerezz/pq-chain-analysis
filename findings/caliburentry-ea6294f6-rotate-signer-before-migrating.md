---
id: caliburentry-ea6294f6-rotate-signer-before-migrating
title: "CaliburEntry: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: none
contracts:
- address: "0xea6294f6d4b231141f04562887a0d06f8df3bd49"
  family: "6d5daa999c3fe77f76a54093d0567224"
  copies: 47265
  name: "CaliburEntry"
  upgradeable: "no"
  rating: LOW
  value_usd: 35728664
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 414542
  last_active: 2026-11-18
  recoveries_14d: 7269
fix:
  layer: onchain-config
  who_acts: "the account"
evidence:
  level: executed
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
  note: "The account controls its key set: LOW."
---

## Summary

Calibur-style 7702 logic (47k accounts). The root key is exempt; a registered secp256k1 key whose address takes code loses use.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: 7702 account logic (47,265 accounts): as above. Bytecode and names. Executed: a real transaction is unaffected by code at the signer.
- reading 6d5daa99: the signer is the account itself or a registered key address
- registered keys are managed by the account through self-calls (register/revoke)

## Impact and exposure

- Value held at block 26,438,999: $35.7M (ETH and 49 priced tokens, over 47,265 addresses).
- Activity: 414,542 transactions called it in the 90 days before that block; last on 2026-11-18.
- 7,269 signature recoveries in the study's two-week trace window.

## Remediation

The account revokes the key and registers a new one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
