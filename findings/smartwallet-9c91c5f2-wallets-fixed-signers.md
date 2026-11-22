---
id: smartwallet-9c91c5f2-wallets-fixed-signers
title: "SmartWallet: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x9c91c5f24fd494487d09c42f7a81818f8f558761"
  family: "3cb1d34daafbc26f29a20ee4a4fc0263"
  name: "SmartWallet"
  upgradeable: "no"
  rating: HIGH
  value_usd: 45
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the wallet signers"
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
  note: "No setter for the signer set, no ERC-1271/code check, not a proxy and no upgrade function; every outflow needs an ecrecovered signer signature, so a fixed signer with code locks the funds. Moving funds out beforehand is a migration step, not a way out."
---

## Summary

BitGo SmartWallet (WalletSimple 0.8) deployed directly and initialised with 3 signers. Every outflow needs a signer caller plus one ecrecovered co-signer.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple (0.8): the second signer must be one of the wallet's three signers, fixed at initialisation, and not the caller, who must be a signer too / BitGo WalletSimple (0.8): returns the…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dossier source SmartWallet.sol: BitGo WalletSimple 0.8: init(address[3]) is onlyUninitialized (initialized()=true); sendMultiSig/Batch/Token are onlySigner plus one ecrecovered other signer; no function changes the signers mapping; no isValidSignature
- init tx at block 15804061 from 0xd189… set signers d189…, acb1…, f2dd… (trace); signers(addr)=true for all three (latest)
- Signers 0xd189eae04247049bddea951d47fa5b58f73e111f, 0xacb129218c87c29f0da897e65cc2b4bdf5fd5ec7, 0xf2dd86bc72d8bc7db1600da2a61739127efd51a4: all EOAs, no code (latest, block ~26452917); value_usd 45, txs_90d 0, last_active None (row)

## Impact and exposure

- Value held at block 26,438,999: $45 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Signers move the funds to a new wallet (or PQ-ready account) before any signer key gets real code; the contract itself cannot be fixed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
