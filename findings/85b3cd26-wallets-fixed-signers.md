---
id: 85b3cd26-wallets-fixed-signers
title: "0x85b3cd26: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x85b3cd2616421d6f2a8a168eab6f42a9fe6784d9"
  family: "f0776e9b07d4e69e22ccc1ed3919cdbc"
  copies: 23
  upgradeable: "no"
  rating: HIGH
  value_usd: 242
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
  note: "Wallet whose fixed owners' signatures (2 of 3 via ecrecover) are the only way to move its funds; proxy target hard-coded, init one-shot and done → HIGH. Signer moving funds out before migrating is a migration step, not a way out."
---

## Summary

58-byte proxy that DELEGATECALLs a hard-coded WalletSimple-style implementation 0x4a94d2a45374e3c071df1db39c9d206b45412be1; initialized with three fixed EOA signers, 2-of-3 (caller signer + ecrecover'd other signer). No upgrade, no signer setter, no other exit: once signer keys get real code the wallet's funds are stuck.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017):…. Same code idiom as template 55e4db93, not read on its own.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Runtime is 0x36600080376110006000366000734a94d2a45374e3c071df1db39c9d206b45412be15af4... (fixed-target delegatecall, no EIP-1967 slots); implementation selectors: sendMultiSig, sendMultiSigToken, init 0x25bc42dc, initialized, signers, isSigner, safeMode, createForwarder, flushForwarderTokens, factory, target, logger.
- init(address,address,address) is guarded by initialized flag (slot 0xe byte 20) and is the only caller of the signers-array writer (jump at 0x0b24 to the array helper); initialized()=true, factory 0x6ffbab2b363e390b814f05ad35972183828a30b7 at block 26438999.
- signers at block 26438999: 0x33b35c665496ba8e71b22373843376740401f106 (EOA, nonce 789); 0x5b8fce37cd787e8a55dfc8db87e732aab119eb2a (EOA, nonce 2); 0xe3c4e792d77066a09886e035b3e6c967bab62a36 (EOA, nonce 1299); cast code latest = 0x for all three.
- Row: value_usd 242, txs_90d 0, last_active null, copies 23 (same proxy code, each with its own signers).

## Impact and exposure

- Value held at block 26,438,999: $242 (ETH and 49 priced tokens, over 23 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Signers move all ETH and tokens to a new wallet (e.g. a 7702-capable or code-checking multisig) with sendMultiSig/sendMultiSigToken before any signer key gets real code; afterwards the wallet only works while two of the three EOA signers keep code-free keys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
