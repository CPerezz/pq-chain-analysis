---
id: synfuturestoken-4b28532f-signed-shortcut-lost
title: "SynFuturesToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x4b28532fb636bab662fff29d56d133c3d9c78857"
  family: "bec32486640a7b222ef7792431f133d6"
  copies: 4
  name: "SynFuturesToken"
  upgradeable: "no"
  rating: LOW
  txs_90d: 21027
  last_active: 2026-11-18
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

SynFuturesToken: EIP-2612 permit require the holder's ECDSA signature; EIP-8151 fails it for a holder with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: as its template 8e54df5e: permit: the owner named in the call must equal the recovered address; the holder can call approve itself. Template.
- approve(address,uint256) is the holder's direct path (selector 0x095ea7b3 in deployed code)
- row note: as its template 8e54df5e: permit: the owner named in the call must equal the recovered address; the holder can call approve itself. Template.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 21,027 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
