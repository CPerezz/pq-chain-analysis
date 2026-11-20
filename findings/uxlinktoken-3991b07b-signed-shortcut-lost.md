---
id: uxlinktoken-3991b07b-signed-shortcut-lost
title: "UXLINKToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x3991b07b2951a4300da8c76e7d2c7edde861fef3"
  family: "a729a71666fb3cdc3138f721becc030f"
  name: "UXLINKToken"
  upgradeable: "no"
  rating: LOW
  txs_90d: 19903
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "the affected holder, by calling approve/delegate itself"
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
  note: "LOW: same act open by approve/delegate to the same party; only a signing convenience is lost."
---

## Summary

UXLINKToken: permit and delegateBySig require the holder's ECDSA signature; EIP-8151 fails it for a holder with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: as its template 849de815: OpenZeppelin 4 upgradeable permit / delegateBySig (OZ upgradeable): whoever signed is the account that delegates; its nonce is checked. Template.
- approve(address,uint256) is the holder's direct path (selector 0x095ea7b3 in deployed code)
- delegate(address) is the direct path for delegateBySig (0x5c19a95c present)
- row note: as its template 849de815: OpenZeppelin 4 upgradeable permit / delegateBySig (OZ upgradeable): whoever signed is the account that delegates; its nonce is checked. Template.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 19,903 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

holder calls approve/delegate directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
