---
id: walletsimple-3fbe1f8f-wallets-fixed-signers
title: "WalletSimple: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x3fbe1f8fc5ddb27d428aa60f661eaaab0d2000ce"
  family: "4a5db10cd5be684d7a01ddd9f7759610"
  copies: 72
  name: "WalletSimple"
  label: "Bithumb: Contract 1"
  upgradeable: "no"
  rating: HIGH
  value_usd: 31990
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
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
  note: "signers read; EOAs today"
---

## Summary

`WalletSimple` at `0x3fbe1f8fc5ddb27d428aa60f661eaaab0d2000ce` (Etherscan tag: Bithumb: Contract 1), with 71 more addresses running its code. A wallet whose signers are fixed in code; once enough of them take code, it can no longer move anything.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017): returns the signer to…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read (BitGo WalletSimple 2017): the sender and a second signer must both be among the wallet's fixed signers.
- State: 3 signers, all EOAs today; it locks once all three have code. 72 copies; no proxy, no upgrade. Dormant.

## Impact and exposure

- Value held at block 26,438,999: $31,990 (ETH and 49 priced tokens, over 72 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
