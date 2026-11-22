---
id: walletsimple-d2ddb846-wallets-fixed-signers
title: "WalletSimple: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd2ddb846a0ee31eb1f7150bfc31d324a4c674c38"
  family: "e703d71f1ea5db6d89288f096adfeebe"
  name: "WalletSimple"
  label: "DeFiato: Wallet 2"
  upgradeable: "no"
  rating: HIGH
  value_usd: 529
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-11-09
  recoveries_14d: 1
fix:
  layer: new-deployment
  who_acts: "wallet owners (move funds to a new wallet before their keys gain code)"
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
  note: "No update path, and the fixed signers' signatures are the only way to move the wallet's own funds (moving funds out before migrating is a migration step, not a way out): HIGH. Value $529, txs_90d 1; value does not lower the rating."
---

## Summary

BitGo WalletSimple (2017): every send needs a signer caller plus one ecrecovered co-signer from the signers fixed at construction.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017): returns the signer to…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source WalletSimple.sol (BitGo 2017): signers set only in the constructor; sendMultiSig/sendMultiSigToken require msg.sender to be a signer and one ecrecovered signer ≠ msg.sender; no setter, no ERC-1271
- Runtime identical to the dossier code.hex; no proxy slots
- signers() at 26438999: 0x6FC1b264… EOA n63, 0x978A1A28… EOA n0, 0x4c6F5638… EOA n3993; safeMode false

## Impact and exposure

- Value held at block 26,438,999: $529 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-11-09.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Owners move the funds to a new wallet before any signer account gets real code; long term, a new wallet that accepts code-bearing signers (ERC-1271) or no longer relies on ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
