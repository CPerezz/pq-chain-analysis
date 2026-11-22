---
id: beef0296-rotate-signer-before-migrating
title: "0xbeef0296: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbeef02961503351625926ea9a11ae13b29f5c555"
  family: "dad22242de6516a695e4d52facbc1d60"
  copies: 2
  upgradeable: "no"
  rating: LOW
  value_usd: 244879
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 14976
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x6b83…7676"
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
  note: "Live EOA owner."
---

## Summary

7702 account logic answering ERC-1271 by stored ECDSA signer (slot 7).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (addOperators, removeOperators, setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- owner (slot 0) sets signer by direct call 0x6c19e783
- owner()=0x6b83e72a…9577 EOA nonce 184 at block

## Impact and exposure

- Value held at block 26,438,999: $244,879 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 14,976 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Owner sets new signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
