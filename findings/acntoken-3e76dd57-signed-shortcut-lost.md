---
id: acntoken-3e76dd57-signed-shortcut-lost
title: "ACNToken: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0x3e76dd57e649a263a532cc9bcc58b32a065fb2a4"
  family: "160acc878919530730f9d8c6658d6454"
  copies: 2
  name: "ACNToken"
  upgradeable: "no"
  rating: NONE
  value_usd: 20
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 36200
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "nobody"
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
  verdict: refuted
  rating: NONE
  note: "the claimed lost path accepts ERC-1271 for a signer with code → refuted per the rubric (a signer whose code does not implement ERC-1271 still fails, but it keeps approve/transfer)."
---

## Summary

ACNToken: the signed path named in the row checks ERC-1271 for a signer with code, so EIP-8151 does not take it away.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a holder whose address has code can no longer use cancelAuthorization, receiveWithAuthorization, transferWithAuthorization; it can still call transfer itself: a way of signing is lost, no right. Rule: permit-like.
- transferWithAuthorization(v,r,s) with an owner whose code returns the ERC-1271 magic value (state override, block 26438999) succeeds (returns 0x)
- ACNToken transferWithAuthorization accepts a holder with code through ERC-1271 (bytecode holds 0x1626ba7e).
- bytecode at block 26438999 (proxy + implementation) holds direct selectors approve 0x095ea7b3, transfer 0xa9059cbb

## Impact and exposure

- Value held at block 26,438,999: $20 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 36,200 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
