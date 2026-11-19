---
id: e2d86d99-wallets-fixed-signers
title: "0xe2d86d99: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xe2d86d998a497211648db0a18883e6b9d25d0400"
  family: "78aa418aaa6b31296f2a9b18842eda95"
  copies: 8
  upgradeable: "no"
  rating: HIGH
  value_usd: 289700
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 42
  last_active: 2026-11-17
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
  note: "owners read; EOAs today"
---

## Summary

Contract `0xe2d86d998a497211648db0a18883e6b9d25d0400`, with 7 more addresses running its code. A wallet whose signers are fixed in code; once enough of them take code, it can no longer move anything.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: multisig with ordered owner signatures and no function name that changes owners (161 ETH). Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode and names: ordered owner signatures, no function changes owners; no proxy, no upgrade.
- State: 5 owners, all EOAs today, threshold 3, so it locks once 3 owners take code.
- 42 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $289,700 (ETH and 49 priced tokens, over 8 addresses).
- Activity: 42 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
