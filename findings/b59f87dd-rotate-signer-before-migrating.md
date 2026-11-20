---
id: b59f87dd-rotate-signer-before-migrating
title: "0xb59f87dd: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb59f87ddf026a78e728fb25df84207e25258d097"
  family: "3c06c7054023d797cda3cca3c8cb41c2"
  copies: 5596
  upgradeable: "no"
  rating: LOW
  txs_90d: 6303
  last_active: 2026-11-18
  recoveries_14d: 1
fix:
  layer: onchain-config
  who_acts: "owner EOA 0xaea9…a5ac"
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

Unverified contract with a stored signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setSignatureRequired, setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- setSigner(address): eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0xaea90102… EOA, nonce 87739

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5,596 addresses).
- Activity: 6,303 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls setSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
