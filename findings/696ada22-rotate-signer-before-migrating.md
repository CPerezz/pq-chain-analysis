---
id: 696ada22-rotate-signer-before-migrating
title: "0x696ada22 (tagged deployed by Bitget Wallet: Deployer 2): signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x696ada227454bd0bf38e8605ab7bacc02a293605"
  family: "ec3ce6ee3f1108b6cab37ab8732e2fd2"
  label: "deployed by Bitget Wallet: Deployer 2"
  upgradeable: "no"
  rating: LOW
  txs_90d: 355715
  last_active: 2026-11-18
  recoveries_14d: 109624
fix:
  layer: onchain-config
  who_acts: "owner Safe 0x9287…6384"
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

Contract with signer and operator sets in storage (addSigners/removeSigners).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (addOperators, addSigners, removeOperators, removeSigners). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- addSigners/removeSigners require msg.sender == owner (error 0x118cdaa7) in decompile
- owner() = 0x9287b8e84d972dd02f618bbed45b9a6d7ed16384 at block 26438999: Safe, threshold 3 of 5

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 355,715 transactions called it in the 90 days before that block; last on 2026-11-18.
- 109,624 signature recoveries in the study's two-week trace window.

## Remediation

Safe adds a fresh EOA signer and removes the old one

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
