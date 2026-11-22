---
id: ownbit-3e408dfe-wallets-fixed-signers
title: "OwnbitMultiSigImplementation: wallet with signers fixed in code"
project: ownbit
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x3e408dfe32f242e36dc9ddc58fa25d30b1c6f754"
  family: "66d724c3ffbff87bddd6b5982592e5e8"
  copies: 158
  name: "OwnbitMultiSigImplementation"
  upgradeable: "no"
  rating: HIGH
  value_usd: 3981098
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 517
  last_active: 2026-11-18
  recoveries_14d: 118
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
  note: "owners read; EOAs today"
---

## Summary

`OwnbitMultiSigImplementation` at `0x3e408dfe32f242e36dc9ddc58fa25d30b1c6f754`, with 157 more addresses running its code. A wallet whose signers are fixed in code; once enough of them take code, it can no longer move anything.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Source read (Ownbit): `required` distinct owners must sign with ECDSA; no function changes the owners.
- State: 3 owners, all EOAs today, required 2, so it locks once 2 owners take code. The 158 addresses are fixed delegates to 0x95ca2f7959f8848795dfb0868c1b0c59dd4e9330; no upgrade.
- Executed: a real transaction reverts once a signer has code. 517 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $4.0M (ETH and 49 priced tokens, over 158 addresses).
- Activity: 517 transactions called it in the 90 days before that block; last on 2026-11-18.
- 118 signature recoveries in the study's two-week trace window.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
