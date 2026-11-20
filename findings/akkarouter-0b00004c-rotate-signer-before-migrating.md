---
id: akkarouter-0b00004c-rotate-signer-before-migrating
title: "AkkaRouter: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0b00004ccc39408fa289e9f6853bfe4eac3e52c8"
  family: "74560b4ce2092e59216e0b8a75a2d153"
  name: "AkkaRouter"
  upgradeable: "no"
  rating: LOW
  txs_90d: 5202
  last_active: 2026-11-18
  recoveries_14d: 3281
fix:
  layer: onchain-config
  who_acts: "owner 0x1f39…7583 (EOA with 7702 delegation)"
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
  note: "setter callable by a live EOA."
---

## Summary

AkkaRouter: fees signed by the stored fee signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- AkkaRouter.sol:75 setFeeSigner onlyOwner; eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0x1f39f9a6… EOA (7702-delegated), nonce 790

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 5,202 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3,281 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls setFeeSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
