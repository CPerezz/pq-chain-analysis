---
id: ef435b99-rotate-signer-before-migrating
title: "0xef435b99: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xef435b99c2108d0309211d0cc05b70d202c0b5df"
  family: "998eed1109415aa440d04a8eaa196999"
  upgradeable: "no"
  rating: LOW
  txs_90d: 94119
  last_active: 2026-11-18
  recoveries_14d: 23614
fix:
  layer: onchain-config
  who_acts: "owner (Safe 0x83fc…906b)"
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
  note: "setter callable by a live Safe."
---

## Summary

Unverified contract (shared owner) whose signatures must come from a stored signer set; a signer with code fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: RFQ: the signer named in the call must be in the rfqSigners set, which setSigner changes. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- setSigner(address,bool): eth_call at block 26438999 from the owner succeeds, from 0x…dEaD reverts (Ownable revert)
- owner() = 0x83fc28e6…, a 3-of-5 Safe

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 94,119 transactions called it in the 90 days before that block; last on 2026-11-18.
- 23,614 signature recoveries in the study's two-week trace window.

## Remediation

Owner adds a new signer and removes the old one with setSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
