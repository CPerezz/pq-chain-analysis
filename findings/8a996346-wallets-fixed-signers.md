---
id: 8a996346-wallets-fixed-signers
title: "0x8a996346: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x8a996346c16619398c1f229c55c65aa7a84e77c8"
  family: "d4fab19c3ed1c56c9f27e9c8d7439b3b"
  copies: 19
  upgradeable: "no"
  rating: HIGH
  value_usd: 26351
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the owners move funds before their signers take code"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "owners fixed"
---

## Summary

Contract `0x8a996346c16619398c1f229c55c65aa7a84e77c8`, with 18 more addresses running its code. A wallet whose signers are fixed in code; once enough of them take code, it can no longer move anything.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: two-of-N spend wallets (19, 15 ETH with tokens; Unchained-style "spendNonce"): owners fixed. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode and names: two-of-N spend wallets (spendNonce), owners fixed at creation; no proxy, no upgrade.
- 19 wallets; dormant.

## Impact and exposure

- Value held at block 26,438,999: $26,351 (ETH and 49 priced tokens, over 19 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
