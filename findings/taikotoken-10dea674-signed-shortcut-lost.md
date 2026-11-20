---
id: taikotoken-10dea674-signed-shortcut-lost
title: "TaikoToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x10dea67478c5f8c5e2d90e5e9b26dbe60c54d800"
  family: "6990d62d5f1f55fec82d102397c225a1"
  copies: 3
  name: "TaikoToken"
  label: "Taiko: TAIKO Token"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 7687
  last_active: 2026-11-18
  recoveries_14d: 5
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

TaikoToken: permit / delegateBySig stops working for a holder whose address has code; the act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 upgradeable permit / delegateBySig (OZ upgradeable): whoever signed is the account that delegates; its nonce is checked. Read from source. Executed: a real transaction reverts with code at the signer.
- bytecode (proxy+implementation 0x5c96ff5b7f61b9e3436ef04da1377c8388dfc106) exposes approve(address,uint256) 0x095ea7b3 and transfer 0xa9059cbb
- bytecode exposes delegate(address) 0x5c19a95c next to delegateBySig 0xc3cda520
- study note: OpenZeppelin 4 upgradeable permit / delegateBySig (OZ upgradeable): whoever signed is the account that delegates; its nonce is checked. Read from source. Executed: a real transacti

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 7,687 transactions called it in the 90 days before that block; last on 2026-11-18.
- 5 signature recoveries in the study's two-week trace window.

## Remediation

Holder calls approve / delegate itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
