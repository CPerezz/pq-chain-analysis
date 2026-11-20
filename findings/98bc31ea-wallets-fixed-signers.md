---
id: 98bc31ea-wallets-fixed-signers
title: "0x98bc31ea: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x98bc31ea2bf7283f4e87c15ef28cf3a386dbad32"
  family: "1955f6c56166f3668d31c7af06a9c6b5"
  upgradeable: "no"
  rating: HIGH
  value_usd: 18
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "the wallet's signers"
evidence:
  level: bytecode
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
  note: "Wallet whose fixed owners' 2-of-3 ecrecover signatures are the only way to move its funds, no update path → HIGH. safeMode only restricts destinations; forwarders only push to the wallet."
---

## Summary

Runs the BitGo WalletSimple 2017 2-of-3 check (caller must be a signer, ecrecover'd second signer must be a different signer); three EOA signers fixed at construction, no setter, no upgrade, no other exit. Funds are stuck once signer keys get real code.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017):…. Same code idiom as template 55e4db93, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Unverified WalletSimple 2017 variant with revert strings ("Invalid signer", "Safe mode is enabled", ...) plus view helpers (0xa2754259/0xd258967b operation-hash getters, 0xed9989c1 recentSequenceIds getter, 0x73bb0cb5 pure hash); same sendMultiSig/sendMultiSigToken check and embedded Forwarder (0x7d251d99 sits in the Forwarder's code, not the wallet's).
- Runtime SSTOREs outside the embedded Forwarder are only safeMode and the sequence-id window; no DELEGATECALL/SELFDESTRUCT, no EIP-1967 implementation slot; main-runtime CALLs only ecrecover, the signed ETH/token sends and value-0 helper calls (forwarder flush/creation, logger).
- signers at block 26438999: 0xe110abb2e909e7e1d2177b59b44f5a465edf062e (EOA, nonce 60); 0xd4e678e050d1840beab60ef7aef54c338f0ec23b (EOA, nonce 0); 0xeda319933e36ef3dc813842b9da448d353819f9f (EOA, nonce 0); cast code latest = 0x for all three (getNextSequenceId 4).
- Row: value_usd 18, txs_90d 0, last_active null, copies 1.

## Impact and exposure

- Value held at block 26,438,999: $18 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Signers move all ETH and tokens to a new wallet (e.g. a 7702-capable or code-checking multisig) with sendMultiSig/sendMultiSigToken before any signer key gets real code; afterwards the wallet only works while two of the three EOA signers keep code-free keys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
