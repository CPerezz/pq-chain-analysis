---
id: walletsimple-6e0fb142-wallets-fixed-signers
title: "WalletSimple: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x6e0fb1420bde64e19f9d4e323f9d2600eaf45f50"
  family: "fd6e46b31c7b68a9b37e10fc690e2ca7"
  name: "WalletSimple"
  upgradeable: "no"
  rating: HIGH
  value_usd: 18
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
  note: "No setter for the signer set, no ERC-1271/code check, not a proxy and no upgrade function; every outflow needs an ecrecovered signer signature, so a fixed signer with code locks the funds. Moving funds out beforehand is a migration step, not a way out. Signers can still co-sign before migrating; once two of the three keys cannot sign, the wallet is locked."
---

## Summary

BitGo WalletSimple (2017), 2 of 3 signers fixed at creation. Spending needs a signer as msg.sender plus one ecrecovered co-signer, so signatures stay mandatory.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017): returns the signer to…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dossier source WalletSimple.sol: BitGo WalletSimple 2017: sendMultiSig/sendMultiSigToken need msg.sender in signers[] plus a second signer from ecrecover (recoverAddressFromSignature), and that second signer must differ from msg.sender; signers[] is set only in the constructor; activateSafeMode only restricts destinations
- runtime code 3494 bytes at 26438999, no EIP-1967 slots, no delegatecall to a settable target
- Signers 0x00A1Cd8A5C61e7EA4D1051264342c7B95F9331d2, 0x003db08AFf103b1D6D097417eeb715aaAa6938EE, 0x00CD6C881619deA54182D70DB5FEABb037331025: all EOAs, no code (latest, block ~26452917); value_usd 18, txs_90d 0, last_active None (row)

## Impact and exposure

- Value held at block 26,438,999: $18 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Signers move the funds to a new wallet (or PQ-ready account) before any signer key gets real code; the contract itself cannot be fixed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
