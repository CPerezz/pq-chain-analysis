---
id: magicinternetmoneyv1-99d8a9c4-signed-shortcut-lost
title: "MagicInternetMoneyV1: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x99d8a9c45b2eca8864373a26d1459e3dff1e17f3"
  family: "fe4aab3f9ae0ae8b8c8fb439418fb420"
  name: "MagicInternetMoneyV1"
  label: "Abracadabra.money: MIM Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 1000
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5222
  last_active: 2026-11-18
fix:
  layer: offchain
  who_acts: "token holder (calls approve itself)"
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
  note: "signed shortcut lost, approve stays open to the same holder → LOW."
---

## Summary

MagicInternetMoneyV1: permit needs the holder's ECDSA signature; under EIP-8151 a holder whose address has code can no longer use it, but keeps approve.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use permit; it can still call approve itself: a way of signing is lost, no right. Rule: permit-like.
- permit(v,r,s) called at block 26438999 with an owner whose code answers ERC-1271 (state override) reverts: recovery-only, no ERC-1271 fallback
- bytecode at block 26438999 (proxy + implementation) holds direct selectors approve 0x095ea7b3, transfer 0xa9059cbb

## Impact and exposure

- Value held at block 26,438,999: $1,000 (ETH and 49 priced tokens).
- Activity: 5,222 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
