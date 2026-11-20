---
id: 8aa60020-wallets-fixed-signers
title: "0x8aa60020: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x8aa60020ae9b4bcdcc9538d2aea4c4c638e094a5"
  family: "f8a92c9c2dd6f772683f3ae3d8ae2920"
  copies: 2
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "wallet signers (move funds to a new wallet before converting any signer key needed for co-signing to code)"
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
  note: "Fixed signer set, owners' own funds, no update path and no exit without a second signer's ecrecover signature -> HIGH per scale (migration step is not a way out). With 3 EOA signers, the wallet keeps working as long as at least one non-caller signer key still recovers."
---

## Summary

BitGo WalletSimple-type 2-of-3 wallet: a send needs msg.sender to be a signer and an ecrecover signature from a different signer; the 3 signers are fixed at construction with no setter, proxy or other exit, so once signer keys get code (beyond one) the owners' funds are locked.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017):…. Same code idiom as template 55e4db93, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Selector set identical to WalletSimple 2017 (sendMultiSig, sendMultiSigToken, signers, isSigner, createForwarder, flushForwarderTokens, getNextSequenceId, safeMode, activateSafeMode; flush/flushTokens are the embedded Forwarder).
- signers(0..2) at block 26438999: 0x0dAB45A61b92e0D71eCfdFC1455A30303E16fE0A, 0xEab49395e91D56Fcd9e3FB43E4dDb494D56Cf284, 0xEA34cC4a37d1450a72c522556BA07460a6eB2D8E; all have code 0x today (EOAs, none delegated/contract).
- Balance at 26438999: 0 ETH; row txs_90d=0, last_active=null, value_usd not in row.
- Only other value-moving paths: forwarder flush (to this wallet) and createForwarder; no EIP-1967 slots, no owner/upgrade function (row upgradeable=no).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Signers move ETH/tokens to a new wallet (e.g. one accepting ERC-1271/7702 signers) before migrating keys to code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
