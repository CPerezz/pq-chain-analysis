---
id: walletsimple-7eb9e1c5-wallets-fixed-signers
title: "WalletSimple: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x7eb9e1c55d39a1180083182453a1d8b102646e1a"
  family: "fd59c28e0a3d7f73432a43a5d5de559c"
  name: "WalletSimple"
  upgradeable: "no"
  rating: HIGH
  value_usd: 5
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

BitGo WalletSimple 0.8 deployed directly (not as a proxy) and initialised with 3 signers. Every outflow needs a signer caller plus one ecrecovered co-signer.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple (0.8): the second signer must be one of the wallet's three signers, fixed at initialisation, and not the caller, who must be a signer too / BitGo WalletSimple (0.8): returns the…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dossier source WalletSimple.sol (verified, this address): BitGo WalletSimple 0.8: init(address[3]) is onlyUninitialized (initialized()=true); sendMultiSig/Batch/Token are onlySigner plus one ecrecovered other signer; no function changes the signers mapping; no isValidSignature
- init tx 0x20d50da3… (block 18452690) set signers 8bcd…, 3cd9…, 857c…; later calls with selector 0xbee3e676 hit the fallback (no such selector in code); signers(addr)=true for all three (latest)
- Signers 0x8bcd49786f90181cd67e35654246b395b47a2891, 0x3cd99b9fa90caa93d754cdbedfa26de7b003b37f, 0x857c723921a799bc86437b9366602a38a44529df: all EOAs, no code (latest, block ~26452917); value_usd 5, txs_90d 0, last_active None (row)

## Impact and exposure

- Value held at block 26,438,999: $5 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Signers move the funds to a new wallet (or PQ-ready account) before any signer key gets real code; the contract itself cannot be fixed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
