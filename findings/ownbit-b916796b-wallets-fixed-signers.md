---
id: ownbit-b916796b-wallets-fixed-signers
title: "OwnbitMultiSig: wallet with signers fixed in code"
project: ownbit
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb916796bacee1d6553b86ae05d9dd4c5e8d0b057"
  family: "2ea7385b391bc907b04dfd08870f6b0d"
  copies: 6
  name: "OwnbitMultiSig"
  upgradeable: "no"
  rating: HIGH
  value_usd: 10082
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5
  last_active: 2026-09-03
fix:
  layer: new-deployment
  who_acts: "the owners move funds before their signers take code"
evidence:
  level: source-read
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

`OwnbitMultiSig` at `0xb916796bacee1d6553b86ae05d9dd4c5e8d0b057`, with 5 more addresses running its code. A wallet whose signers are fixed in code; once enough of them take code, it can no longer move anything.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig (variant with inactivity): distinct owners by ECDSA; owners cannot be changed, inactive ones lower the number required. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read (Ownbit with inactivity): owners cannot be changed; inactive owners lower the number required, so it locks only when every owner has code.
- State: 3 owners, all EOAs today. No proxy, no upgrade. 5 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $10,082 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 5 transactions called it in the 90 days before that block; last on 2026-09-03.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
