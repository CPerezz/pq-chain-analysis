---
id: walletsimple-78b3b8ae-wallets-fixed-signers
title: "WalletSimple: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x78b3b8ae77b1cee86d62ed964d74dc4a69c172a5"
  family: "ee1654f959e318efa069f759b4ada3a5"
  copies: 144
  name: "WalletSimple"
  upgradeable: "no"
  rating: HIGH
  value_usd: 41017
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
  note: "signers fixed"
---

## Summary

`WalletSimple` at `0x78b3b8ae77b1cee86d62ed964d74dc4a69c172a5`, with 143 more addresses running its code. A wallet whose signers are fixed in code; once enough of them take code, it can no longer move anything.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple (variant): the second signer must be one of the wallet's fixed signers and not the caller / BitGo WalletSimple (0.8): returns the signer to verifyMultiSig; read in full for the…. Read from source.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Source read (BitGo WalletSimple variant): the second signer must be one of the wallet's fixed signers and not the caller; it locks once every signer has code.
- 144 fixed delegates; no upgrade. Dormant.

## Impact and exposure

- Value held at block 26,438,999: $41,017 (ETH and 49 priced tokens, over 144 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
