---
id: coordinator-c0ca6854-rotate-signer-before-migrating
title: "Coordinator: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc0ca685456363ed2d7521dfc47e0be165a99eb44"
  family: "f9e9ca2770c1059502755ce146af9aa2"
  copies: 16
  name: "Coordinator"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1478
  last_active: 2026-11-18
  recoveries_14d: 30
fix:
  layer: onchain-config
  who_acts: "owner Safe 4-of-7"
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
  note: "Owner-only list setters exist; the owner is a live 4-of-7 Safe."
---

## Summary

Coordinator: EIP-712 signatures must recover to a stored executor or publisher; such a party holding code would be rejected.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Coordinator: the signer must be an executor or a publisher of the stored lists. Read from source.
- source Coordinator.sol: addExecutor/removeExecutor/addPublisher/removePublisher are onlyOwner (lines 421–489); the check uses ECDSA.recover against those lists (line 1567), no ERC-1271
- renounceOwnership disabled, so the owner cannot be dropped
- owner 0x6454cf0127a153295435160768C85225Cd19Bf15 is a Safe 4-of-7 (probe)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 16 addresses).
- Activity: 1,478 transactions called it in the 90 days before that block; last on 2026-11-18.
- 30 signature recoveries in the study's two-week trace window.

## Remediation

Owner Safe adds plain-key executors/publishers and removes the affected ones.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
