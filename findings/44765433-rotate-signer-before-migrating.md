---
id: 44765433-rotate-signer-before-migrating
title: "0x44765433: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x447654338fba13ce25988cc576b2903ac7cdcec3"
  family: "0b29091f20cc4f24a9c1992e52d16dd8"
  copies: 2
  upgradeable: "no"
  rating: LOW
  txs_90d: 233441
  last_active: 2026-11-18
  recoveries_14d: 1928
fix:
  layer: onchain-config
  who_acts: "owner (Safe 0x9287…6384)"
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
  note: "setter present and callable by a live Safe."
---

## Summary

Unverified contract whose signer is the stored operator; an operator with code fails the check.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the account itself or an operator, which setOperator replaces. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- setOperator(address): eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts
- owner() = 0x9287b8e8…, a 3-of-5 Safe; operator() = 0x5db8606f…

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 233,441 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,928 signature recoveries in the study's two-week trace window.

## Remediation

Owner replaces the operator via setOperator.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
