---
id: ownbit-ac48c371-wallets-fixed-signers
title: "OwnbitMultiSig: wallet with signers fixed in code"
project: ownbit
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xac48c3712cc677d59566c37e6eb5eccccd207d1b"
  family: "bd7bb1ad5360b14876615c66a4fcd3f2"
  copies: 139
  name: "OwnbitMultiSig"
  upgradeable: "no"
  rating: HIGH
  value_usd: 1322258
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-11-13
  recoveries_14d: 1
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

`OwnbitMultiSig` at `0xac48c3712cc677d59566c37e6eb5eccccd207d1b`, with 138 more addresses running its code. A wallet whose signers are fixed in code; once enough of them take code, it can no longer move anything.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig (older): `required` distinct owners by ECDSA; no function changes the owners. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read (Ownbit, older): `required` distinct owners by ECDSA; no function changes the owners.
- State: 2 owners, both EOAs today. No proxy, no upgrade.
- Executed: a real transaction reverts once a signer has code. 2 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $1.3M (ETH and 49 priced tokens, over 139 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-13.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
