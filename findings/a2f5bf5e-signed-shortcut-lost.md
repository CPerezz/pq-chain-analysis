---
id: a2f5bf5e-signed-shortcut-lost
title: "0xa2f5bf5e: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xa2f5bf5eb1b8894a514162ca7abe5f095a5371b1"
  family: "b4da8554d5fd9bcb6952869422eee5c4"
  copies: 5761
  upgradeable: "no"
  rating: LOW
  value_usd: 402056
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-11-13
fix:
  layer: account-migration
  who_acts: "the wallet's keys"
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
  note: "Funds and key management open by direct call → LOW. Bytecode only."
---

## Summary

Unverified key-based wallet (5,761 accounts): legacy ERC-1271 isValidSignature recovers a key; a key with code makes signatures invalid.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: device-based account (5,761 accounts, 223 ETH with tokens; Archanova-like): a signature counts when it recovers to a registered device; devices add and remove devices and also act by direct call. A…. Bytecode and names.
- 0x3f579f42 execute: direct call by a flagged key, no signature
- 0x811d54dc add key / 0x1f7b6324 remove key: direct calls by a flagged key
- only the off-chain signature acceptance is lost

## Impact and exposure

- Value held at block 26,438,999: $402,056 (ETH and 49 priced tokens, over 5,761 addresses).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-11-13.

## Remediation

Keys act directly and add a new EOA signing key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
