---
id: qredowalletimplementation-1c6c390a-wallets-fixed-signers
title: "QredoWalletImplementation: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x1c6c390a6625f66a512f22ccad0d6ffcfdd01247"
  family: "f00feccde7fca4f0563b43df89ac8d2d"
  copies: 5562
  name: "QredoWalletImplementation"
  upgradeable: "no"
  rating: HIGH
  value_usd: 11196
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
  note: "owner fixed"
---

## Summary

`QredoWalletImplementation` at `0x1c6c390a6625f66a512f22ccad0d6ffcfdd01247`, with 5,561 more addresses running its code. A wallet whose signers are fixed in code; once enough of them take code, it can no longer move anything.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Qredo wallet onlySigner: every call must be signed by _walletOwner; no function among its names changes the owner or lets it call directly. Read from source.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Source read (QredoWalletImplementation): every call must be signed by _walletOwner; no function changes the owner or lets it call directly.
- 5,562 fixed delegates; no upgrade. Dormant.

## Impact and exposure

- Value held at block 26,438,999: $11,196 (ETH and 49 priced tokens, over 5,562 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
