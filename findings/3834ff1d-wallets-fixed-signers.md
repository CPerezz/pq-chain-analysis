---
id: 3834ff1d-wallets-fixed-signers
title: "0x3834ff1d: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x3834ff1dbfa896c474b626ea461c415eb00e023e"
  family: "41447cf228b83caac831d35f17535080"
  copies: 4
  upgradeable: "no"
  rating: HIGH
  txs_90d: 3
  last_active: 2026-08-29
fix:
  layer: new-deployment
  who_acts: "wallet signers (move funds to a new wallet before any signer key gets code)"
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
  note: "Fixed signer set, no update path, and the owners' own funds move only with a recoverable co-signer signature, so HIGH. All three signers are EOAs today. The caller role needs no signature, so a coded signer can still be msg.sender if its code can make calls; each send still needs one other signer whose EOA key recovers."
---

## Summary

BitGo WalletSimple: sendMultiSig/sendMultiSigToken need msg.sender to be a signer plus an ecrecover'd co-signer from the fixed 3-signer set; signers fixed at construction, no setter, no other exit. Once a signer key gets real code its signatures stop recovering; when no signer other than the caller can produce a recoverable signature, the wallet's ETH/tokens are locked. value_usd not set in row, txs_90d 3, last_active 2026-08-29.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017):…. Same code idiom as template 55e4db93, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- code: WalletSimple build with exactly the template's selector set (different compiler output/size); local anvil run of this runtime with signers set to test keys: all-zero signature reverts, valid co-signer signature executes (signature check is real)
- signers(0..2) at 26438999: 0x8365c63000b5Ed2a545D96e1A19E524315847ed7 (EOA, nonce 98), 0x104464276B222a36e5f2834B5B12bE3aEE28438E (EOA, nonce 0), 0x75994AbB849Db112c69A5b90c1029352B718E4c2 (EOA, nonce 0); signers(3) reverts; code and nonces of all three signers read on reth at latest, block ~26452855: all 0x (EOA)
- EIP-1967 implementation slot 0; no upgrade/owner/signer-setter selector in dispatcher; fallback only logs deposits, forwarders flush only to the wallet, activateSafeMode only restricts destinations; row.copies 4

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-08-29.

## Remediation

Signers move all ETH/tokens to a wallet whose signer set can change (or accepts ERC-1271) before any signer key is migrated to code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
