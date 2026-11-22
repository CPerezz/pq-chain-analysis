---
id: vaitoken-d13cfd31-signed-shortcut-lost
title: "VAIToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xd13cfd3133239a3c73a9e535a5c4dadee36b395c"
  family: "0fa9cfd36de966bedc71ba9e37d40eb6"
  name: "VAIToken"
  upgradeable: "no"
  rating: LOW
  value_usd: 100
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 14504
  last_active: 2026-11-18
fix:
  layer: offchain
  who_acts: "token holder (calls approve itself)"
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
  note: "signed shortcut lost, approve stays open to the same holder → LOW."
---

## Summary

VAIToken: meta-transaction relay needs the holder's ECDSA signature; under EIP-8151 a holder whose address has code can no longer use it, but keeps approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: meta-transaction relay (NativeMetaTransaction): the user named in the call must have signed; the relayed functions are open to the user's own call. Read (function text).
- NativeMetaTransaction.executeMetaTransaction: the user named must have signed; relayed functions (approve/transfer) are callable by the user directly
- bytecode at block 26438999 (proxy + implementation) holds direct selectors approve 0x095ea7b3, transfer 0xa9059cbb

## Impact and exposure

- Value held at block 26,438,999: $100 (ETH and 49 priced tokens).
- Activity: 14,504 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
