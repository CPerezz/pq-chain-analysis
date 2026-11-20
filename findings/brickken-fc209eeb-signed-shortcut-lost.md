---
id: brickken-fc209eeb-signed-shortcut-lost
title: "Brickken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xfc209eeba3d744aa741cc5c2a73ebf9c977b5f82"
  family: "e88cb4702f9879a0ba06e18206b08ccc"
  name: "Brickken"
  upgradeable: "no"
  rating: LOW
  txs_90d: 8045
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "the affected holder (calls the direct function itself)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Standard signed shortcut; approve and delegate remain open to the same holder."
---

## Summary

Brickken: permit / delegateBySig stops working for a holder whose address has code; the act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: as its template 5f7e8cb7: delegateBySig (OZ 5 Votes): whoever signed is the account that delegates / OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Template.
- bytecode exposes approve(address,uint256) 0x095ea7b3 and transfer 0xa9059cbb
- bytecode exposes delegate(address) 0x5c19a95c next to delegateBySig 0xc3cda520
- study note: as its template 5f7e8cb7: delegateBySig (OZ 5 Votes): whoever signed is the account that delegates / OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Te

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 8,045 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Holder calls approve / delegate itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
