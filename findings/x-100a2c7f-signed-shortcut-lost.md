---
id: x-100a2c7f-signed-shortcut-lost
title: "X: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x100a2c7f45fd48e217fdce72e658dc78fd43a100"
  family: "c791e5ad937058f8388769b5daef4579"
  name: "X"
  upgradeable: "no"
  rating: LOW
  txs_90d: 20792
  last_active: 2026-11-12
fix:
  layer: none
  who_acts: "the affected holder, by calling approve itself"
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
  note: "LOW: same act open by approve to the same party; only a signing convenience is lost."
---

## Summary

X: EIP-2612 permit require the holder's ECDSA signature; EIP-8151 fails it for a holder with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: as its template 8e54df5e: permit: the owner named in the call must equal the recovered address; the holder can call approve itself. Template.
- approve(address,uint256) is the holder's direct path (selector 0x095ea7b3 in deployed code)
- row note: as its template 8e54df5e: permit: the owner named in the call must equal the recovered address; the holder can call approve itself. Template.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 20,792 transactions called it in the 90 days before that block; last on 2026-11-12.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
