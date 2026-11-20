---
id: dolaborrowingrights-ad038eb6-signed-shortcut-lost
title: "DolaBorrowingRights: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xad038eb671c44b853887a7e32528fab35dc5d710"
  family: "653f6f3b816c516dd2a51bfce4ded4d3"
  name: "DolaBorrowingRights"
  label: "Inverse Finance: DBR Token"
  upgradeable: "no"
  rating: LOW
  txs_90d: 27357
  last_active: 2026-11-18
  recoveries_14d: 1
fix:
  layer: none
  who_acts: "the affected holder, by calling approve itself"
evidence:
  level: source-read
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
  note: "LOW: same act open by approve to the same party; only a signing convenience is lost."
---

## Summary

DolaBorrowingRights: EIP-2612 permit require the holder's ECDSA signature; EIP-8151 fails it for a holder with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here. Read from source.
- approve(address,uint256) is the holder's direct path (selector 0x095ea7b3 in deployed code)
- row note: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here. Read from source.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 27,357 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
