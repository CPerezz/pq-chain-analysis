---
id: ownbit-f2c50016-wallets-fixed-signers
title: "OwnbitMultiSigImplementation: wallet with signers fixed in code"
project: ownbit
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xf2c5001639628e63c866815e55ab5cb24bb3cae4"
  family: "3180553b365b24f02ab3a72473104dd0"
  copies: 8
  name: "OwnbitMultiSigImplementation"
  upgradeable: "no"
  rating: HIGH
  value_usd: 511199
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 49
  last_active: 2026-11-17
  recoveries_14d: 62
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
  note: "owners read; EOAs today; 2 of 2"
---

## Summary

`OwnbitMultiSigImplementation` at `0xf2c5001639628e63c866815e55ab5cb24bb3cae4`, with 7 more addresses running its code. A wallet whose signers are fixed in code; once enough of them take code, it can no longer move anything.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners / Ownbit standard multisig _recoverPacked: returns the signer or…. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Source read (Ownbit, standard multisig): `required` distinct owners by ECDSA, also in its ERC-1271; no function changes the owners.
- State: 2 owners, both EOAs today, required 2, so it locks once one owner takes code. Fixed delegates to 0x8ff6ebd112577e471530d175ce151f1dcbdc4b8a; no upgrade.
- 49 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $511,199 (ETH and 49 priced tokens, over 8 addresses).
- Activity: 49 transactions called it in the 90 days before that block; last on 2026-11-17.
- 62 signature recoveries in the study's two-week trace window.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
