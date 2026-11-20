---
id: chain-a2cd3d43-signed-shortcut-lost
title: "Chain: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xa2cd3d43c775978a96bdbf12d733d5a1ed94fb18"
  family: "9f9ddecc62cdd67e6f66c74716bbaa20"
  name: "Chain"
  upgradeable: "no"
  rating: LOW
  txs_90d: 119414
  last_active: 2026-11-18
fix:
  layer: offchain
  who_acts: "token holder (calls delegate itself)"
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
  note: "signed shortcut lost, delegate stays open to the same holder → LOW."
---

## Summary

Chain: delegateBySig needs the holder's ECDSA signature; under EIP-8151 a holder whose address has code can no longer use it, but keeps delegate.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use delegateBySig; it can still call delegate itself: a way of signing is lost, no right. Rule: permit-like.
- bytecode at block 26438999 (proxy + implementation) holds direct selectors approve 0x095ea7b3, transfer 0xa9059cbb, delegate 0x5c19a95c

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 119,414 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

holder calls delegate directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
