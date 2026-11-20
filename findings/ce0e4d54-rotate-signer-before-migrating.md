---
id: ce0e4d54-rotate-signer-before-migrating
title: "0xce0e4d54: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xce0e4d548735137d3b3afcbaaf47800b88eb0b6a"
  family: "1bbffa52c7e3f865f806de7bbd7cb7cc"
  copies: 3
  upgradeable: "no"
  rating: LOW
  value_usd: 950281
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 76662
  last_active: 2026-11-18
  recoveries_14d: 12574
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN (EOA 0xF3B3a4ed)"
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
  note: "LOW: live EOA admin (assuming DEFAULT_ADMIN administers the signer role, the usual OZ default)."
---

## Summary

Unverified token holder answering ERC-1271 for signer-role holders, ECDSA only.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (grantRole, revokeRole). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- getRoleMember(DEFAULT_ADMIN_ROLE, 0) = 0xF3B3a4ed = owner(); EOA, nonce 1693
- reading 1bbffa52: rotation via grantRole/revokeRole by the role admin

## Impact and exposure

- Value held at block 26,438,999: $950,281 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 76,662 transactions called it in the 90 days before that block; last on 2026-11-18.
- 12,574 signature recoveries in the study's two-week trace window.

## Remediation

The admin grants the signer role to a fresh key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
