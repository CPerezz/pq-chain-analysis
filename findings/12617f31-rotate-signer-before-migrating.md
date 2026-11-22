---
id: 12617f31-rotate-signer-before-migrating
title: "0x12617f31: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x12617f31a29dccff3790e4767239a7b00928d43b"
  family: "e195b6e9d03e17264e89ad4ee2bc2c25"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  value_usd: 15339
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-10-17
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN_ROLE holder 0x914b776b… (7702-delegated EOA)"
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
  note: "Role setter with a live admin; the proxy is also upgradeable."
---

## Summary

No-source pre-market contract (orders, offers, settleFilledWithDiscount): discount signatures must recover to an address holding a role (storage_map_d role 0x86e06a81…).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (grantRole, revokeRole, updateConfig). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- heimdall decompile of impl 0x919f2936… line 90: 'Invalid discount signature' unless the recovered address holds role 0x86e06a81…
- grantRole/revokeRole present (AccessControl); hasRole(0x00, 0x914b776b…) = true
- 0x914b776b…: 7702-delegated EOA (0xef0100…), nonce 220

## Impact and exposure

- Value held at block 26,438,999: $15,339 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-17.

## Remediation

The admin grants the role to a new EOA and revokes the old one. Non-discount settle/cancel paths remain.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
