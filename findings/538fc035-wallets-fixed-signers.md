---
id: 538fc035-wallets-fixed-signers
title: "0x538fc035: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x538fc0351b2f522feb0ef9d7478558940a52fdd5"
  family: "70d8c7aa488ff524c8d5d3cfe32c2072"
  copies: 26
  upgradeable: "no"
  rating: HIGH
  value_usd: 1481
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "wallet owners (move funds to a new wallet before their keys gain code)"
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
  note: "No update path, and the fixed signers' signatures are the only way to move the wallet's own funds (moving funds out before migrating is a migration step, not a way out): HIGH. Value $1481, txs_90d 0; value does not lower the rating."
---

## Summary

A minimal forwarding proxy to 0x9957e95e…, a BitGo WalletSimple-like wallet (sendMultiSig/sendMultiSigToken with expiry): a signer caller plus an ecrecovered co-signer; the clone's signers are written only by its creation code.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple-like wallet (sendMultiSig, createForwarder): the second signer must be one of the signers set at creation; no function changes them. Bytecode and names (no source).
- Update path, read at block 26,438,999: delegates to a fixed address.
- 47-byte forwarding proxy (CALLDATACOPY; DELEGATECALL to a hard-coded implementation with gas-50; returns 32 bytes): no proxy slots, no upgrade; target 0x9957e95eb9b421483c608c8291e34524d344201e (4829 bytes)
- Implementation decompiled: no init function; runtime SSTOREs only safeMode (slot 1), sequence ids (slot 2) and the embedded forwarder initcode; recoverAddressFromSignature is the only ecrecover use; no SELFDESTRUCT
- signers() via the clone at 26438999: 0x21688102… EOA n0, 0xA26Ab4e1… EOA n0, 0x6b043e90… EOA n6549; safeMode false

## Impact and exposure

- Value held at block 26,438,999: $1,481 (ETH and 49 priced tokens, over 26 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move the funds to a new wallet before any signer account gets real code; long term, a new wallet that accepts code-bearing signers (ERC-1271) or no longer relies on ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
