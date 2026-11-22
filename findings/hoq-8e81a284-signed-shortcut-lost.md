---
id: hoq-8e81a284-signed-shortcut-lost
title: "HoQ: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x8e81a2844bedfb50ed774083bc3538e23cca6a35"
  family: "8448e6d4a7cf7ecec1dad115d3c7b835"
  name: "HoQ"
  upgradeable: "no"
  rating: LOW
  value_usd: 9203
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4
  last_active: 2026-09-25
fix:
  layer: offchain
  who_acts: "user with code"
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
  note: "Direct path, same party. Value $9203, txs_90d 4 (not rating inputs)."
---

## Summary

HoQ NFT with NativeMetaTransaction: a user with code can't sign meta-transactions, but every relayed function is open to its own call (ContextMixin.msgSender falls back to msg.sender).

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: meta-transaction relay (NativeMetaTransaction): the user named in the call must have signed; the relayed functions are open to the user's own call. Read from source.
- source HoQ.sol:218 _msgSender() → ContextMixin.msgSender(); ContentMixin.sol: msg.sender unless called by self

## Impact and exposure

- Value held at block 26,438,999: $9,203 (ETH and 49 priced tokens).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-09-25.

## Remediation

Call the functions directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
