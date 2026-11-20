---
id: nonfungiblepositionmanager-4857db57-rotate-signer-before-migrating
title: "NonfungiblePositionManager: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4857db576ee0e45f10525ec59527bfd10beec60b"
  family: "2ae9a7f9fbfc4cfa9a3afe3462bef929"
  copies: 2
  name: "NonfungiblePositionManager"
  upgradeable: "no"
  rating: LOW
  txs_90d: 150991
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "owner (Safe 0x4225…4ce0)"
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
  note: "the checked key is the owner itself and the owner Safe can rotate it (a Safe as owner already has code, so the signer check likely concerns a different key or is unused by it — reviewer may want a look)."
---

## Summary

NonfungiblePositionManager fork whose signed path checks the stored owner; an owner with code fails it.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one address in storage and the only such address the code names is its owner, which can be handed over (setOwner). Rule: stored-key (the owner).
- setOwner(address): eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0x42255e3c…, a 3-of-7 Safe

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 150,991 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Owner hands over to a new key with setOwner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
