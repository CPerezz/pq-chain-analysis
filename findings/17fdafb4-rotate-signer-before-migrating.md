---
id: 17fdafb4-rotate-signer-before-migrating
title: "0x17fdafb4: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x17fdafb44736e7a88348fc560d8b738da73d8f68"
  family: "2703a38d4ce606d3df619da3962c262a"
  upgradeable: "no"
  rating: LOW
  txs_90d: 6106
  last_active: 2026-11-18
  recoveries_14d: 4570
fix:
  layer: onchain-config
  who_acts: "owner (Safe 0x5b8c…b803)"
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
  note: "setter held by a live Safe."
---

## Summary

Unverified contract with an operator signer set.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setOperator). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- setOperator(address[],bool): eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0x5b8c76e2…, a 1-of-3 Safe

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 6,106 transactions called it in the 90 days before that block; last on 2026-11-18.
- 4,570 signature recoveries in the study's two-week trace window.

## Remediation

Owner swaps operators.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
