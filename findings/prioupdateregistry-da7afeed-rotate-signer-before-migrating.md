---
id: prioupdateregistry-da7afeed-rotate-signer-before-migrating
title: "PrioUpdateRegistry: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xda7afeed021eafc1c1af9c362de477dad0396b81"
  family: "78db403a17a52f48c8eb7e4a9e66ccad"
  name: "PrioUpdateRegistry"
  upgradeable: "no"
  rating: LOW
  txs_90d: 364507
  last_active: 2026-11-18
  recoveries_14d: 22228
fix:
  layer: onchain-config
  who_acts: "each target"
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
  note: "stored per-target key replaceable by the target itself; direct paths exist"
---

## Summary

PrioUpdateRegistry: signed state updates by an updater the target registered, or by the target via ERC-1271.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: an updater registered by the target signs with ECDSA; or the target itself is asked through ERC-1271. Read from source. Executed: a real transaction reverts with code at the signer.
- PrioUpdateRegistry.sol: addUpdater/removeUpdater are called directly by the target (msg.sender), and updateState lets an updater write directly without a signature
- batchUpdateStateWithSignature accepts signer == target via SignatureCheckerLib ERC-1271

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 364,507 transactions called it in the 90 days before that block; last on 2026-11-18.
- 22,228 signature recoveries in the study's two-week trace window.

## Remediation

target removes the coded updater and adds a fresh EOA, or signs as itself via ERC-1271

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
