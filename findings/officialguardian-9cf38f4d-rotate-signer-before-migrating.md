---
id: officialguardian-9cf38f4d-rotate-signer-before-migrating
title: "OfficialGuardian: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9cf38f4db6ce5c4b0f6abd419d38429625f7a5a2"
  family: "6a92012854f3e624d693f0d7ea31a6b0"
  copies: 2
  name: "OfficialGuardian"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 9231
  last_active: 2026-10-03
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x4374…2768"
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
  note: "setter callable by a live EOA."
---

## Summary

OfficialGuardian: manager set signs; a manager with code fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (addManager, removeManager). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- addManager(address): eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts (UNAUTHORIZED)
- owner() = 0x4374d3d0… EOA, nonce 2489

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 9,231 transactions called it in the 90 days before that block; last on 2026-10-03.

## Remediation

Owner adds a new manager and removes the old.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
