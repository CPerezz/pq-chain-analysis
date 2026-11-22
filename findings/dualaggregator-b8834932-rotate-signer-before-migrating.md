---
id: dualaggregator-b8834932-rotate-signer-before-migrating
title: "DualAggregator: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb88349328bcb41219b15e7d56c9d64692c8356af"
  family: "7b414d740c2aac525d7d3d9dfb968b17"
  copies: 46
  name: "DualAggregator"
  upgradeable: "no"
  rating: LOW
  txs_90d: 273322
  last_active: 2026-11-18
  recoveries_14d: 52845
fix:
  layer: onchain-config
  who_acts: "owner (Safe 0x21f7…73ca)"
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
  note: "setter exists and is held by a live Safe."
---

## Summary

Chainlink OCR DualAggregator: reports need a quorum of distinct signers from the stored set; a signer with code makes reports fail.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (oracle, committee member, validator) and distinct; a quorum is needed. Read from source. Executed: a real transaction reverts with code at the signer.
- DualAggregator.sol:178 setConfig(signers,…) is onlyOwner and replaces the signer set
- owner() at block = 0x21f73d42… , a 4-of-9 Safe

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 46 addresses).
- Activity: 273,322 transactions called it in the 90 days before that block; last on 2026-11-18.
- 52,845 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls setConfig with new signer keys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
