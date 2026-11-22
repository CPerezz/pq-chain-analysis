---
id: 06a4ef39-wallets-fixed-signers
title: "0x06a4ef39: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x06a4ef39e077471214e4a8bfa0cbbe34e88849a2"
  family: "cd61b9c1f06011b88b0a15a37fb04339"
  copies: 74
  upgradeable: "no"
  rating: HIGH
  value_usd: 35715
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1533
  last_active: 2026-11-18
  recoveries_14d: 44
fix:
  layer: new-deployment
  who_acts: "the owners move funds before their signers take code"
evidence:
  level: executed
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
  note: "signers fixed; active"
---

## Summary

Contract `0x06a4ef39e077471214e4a8bfa0cbbe34e88849a2`, with 73 more addresses running its code. A wallet whose signers are fixed in code; once enough of them take code, it can no longer move anything.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: 74 wallets: signers in a stored set (signerNum); no function name that changes them. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode and names: signers in a stored set (signerNum), set at initialisation; no setter; no proxy, no upgrade.
- Executed: a real transaction reverts once a signer has code. 1,533 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $35,715 (ETH and 49 priced tokens, over 74 addresses).
- Activity: 1,533 transactions called it in the 90 days before that block; last on 2026-11-18.
- 44 signature recoveries in the study's two-week trace window.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
