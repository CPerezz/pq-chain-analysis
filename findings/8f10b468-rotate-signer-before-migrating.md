---
id: 8f10b468-rotate-signer-before-migrating
title: "0x8f10b468 (tagged KyberSwap: Aggregation Executor Proxy): signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8f10b468b06c6fd214b65f87778827f7d113f996"
  family: "32377d14096e920c7179b831cd298d5f"
  copies: 2
  label: "KyberSwap: Aggregation Executor Proxy"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 998923
  last_active: 2026-11-18
  recoveries_14d: 19641
fix:
  layer: onchain-config
  who_acts: "default admin 0x5679…59BE"
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
  note: "role setter callable by a live EOA default admin (assumes the signer role's admin is DEFAULT_ADMIN_ROLE; the role hash was not decoded)"
---

## Summary

Contract with AccessControlDefaultAdminRules; signers are role holders (grantRole/revokeRole).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (grantRole, revokeRole). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- grantRole is role-admin gated (error 0xe2517d3f) in decompile
- defaultAdmin() = owner() = 0x56792D335D510B313FA521747559821525a459BE at block 26438999; EOA, nonce 83

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 998,923 transactions called it in the 90 days before that block; last on 2026-11-18.
- 19,641 signature recoveries in the study's two-week trace window.

## Remediation

default admin grants the signer role to a fresh EOA and revokes the old one

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
