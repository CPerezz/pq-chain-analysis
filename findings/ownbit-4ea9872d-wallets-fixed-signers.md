---
id: ownbit-4ea9872d-wallets-fixed-signers
title: "OwnbitMultiSigImplementation: wallet with signers fixed in code"
project: ownbit
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x4ea9872da75e204182a5011d347374ab3e50b96e"
  family: "0a0deb27b81ede8bbf34748ea86200eb"
  copies: 16
  name: "OwnbitMultiSigImplementation"
  upgradeable: "no"
  rating: HIGH
  value_usd: 101162
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 158
  last_active: 2026-11-17
  recoveries_14d: 33
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
  note: "owners read; inactivity lowers the threshold"
---

## Summary

`OwnbitMultiSigImplementation` at `0x4ea9872da75e204182a5011d347374ab3e50b96e`, with 15 more addresses running its code. A wallet whose signers are fixed in code; once enough of them take code, it can no longer move anything.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig (variant): distinct owners by ECDSA; no function changes the owners, but owners inactive for long lower the number required. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Source read (Ownbit variant): distinct owners by ECDSA; no function changes the owners; owners inactive for long lower the number required, so it locks only when every owner has code.
- State: 2 owners, both EOAs today, required 2. Fixed delegates to 0x89e816865646d5a88a8f38518a3964a6c31ae5f4; no upgrade.
- 158 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $101,162 (ETH and 49 priced tokens, over 16 addresses).
- Activity: 158 transactions called it in the 90 days before that block; last on 2026-11-17.
- 33 signature recoveries in the study's two-week trace window.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
