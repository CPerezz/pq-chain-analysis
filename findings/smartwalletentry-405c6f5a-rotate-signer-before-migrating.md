---
id: smartwalletentry-405c6f5a-rotate-signer-before-migrating
title: "SmartWalletEntry: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: none
contracts:
- address: "0x405c6f5acd29dc6b72f3cce8e4f6a76fa3d53c7a"
  family: "099a9a9fdb147cdb55cfae5217bcf9bc"
  copies: 9172
  name: "SmartWalletEntry"
  upgradeable: "yes"
  rating: LOW
  value_usd: 4722894
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 72510
  last_active: 2026-11-18
  recoveries_14d: 588
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
  note: "LOW: setter controlled by the account plus the direct path."
---

## Summary

SmartWalletEntry 7702 logic (9.2k accounts). The account's own key is exempt; another registered ECDSA owner that takes code loses its signature paths.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a 65-byte signature must recover to the account itself; longer ones go to other signers the account added. Read from source. Executed: a real transaction is unaffected by code at the signer.
- reading 099a9a9f: 587 of 588 recoveries were the account's own key; another owner can still call execute directly
- owners are added and removed by the account

## Impact and exposure

- Value held at block 26,438,999: $4.7M (ETH and 49 priced tokens, over 9,172 addresses).
- Activity: 72,510 transactions called it in the 90 days before that block; last on 2026-11-18.
- 588 signature recoveries in the study's two-week trace window.

## Remediation

The account removes or replaces the owner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
