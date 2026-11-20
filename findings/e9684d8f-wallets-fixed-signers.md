---
id: e9684d8f-wallets-fixed-signers
title: "0xe9684d8f: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xe9684d8f18f87371fff41782cd764f4d62b70ddb"
  family: "afba64ae92917b3c4b74151d74c8a41c"
  copies: 13
  upgradeable: "no"
  rating: HIGH
  value_usd: 905
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
  note: "No update path, and the fixed signers' signatures are the only way to move the wallet's own funds (moving funds out before migrating is a migration step, not a way out): HIGH. Value $905, txs_90d 0; value does not lower the rating."
---

## Summary

An old BitGo WalletSimple (sendMultiSig with expiry, createForwarder, destinationAddress) holding its own code: a signer caller plus an ecrecovered co-signer from signers fixed at construction.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple-like wallet (sendMultiSig, createForwarder): the second signer must be one of the signers set at creation; no function changes them. Bytecode and names (no source).
- Update path, read at block 26,438,999: delegates to a fixed address.
- Same selector set and decompiled logic as 0x3fcc636d… (the implementation behind 0x26aedb99…); the code holds itself (3054 bytes), so the row note's 'delegates to a fixed address' does not apply; no proxy slots
- Runtime SSTOREs: safeMode, sequence id and the forwarder initcode only; no init, no signer setter
- signers() at 26438999: 0xaa34C915… EOA n114, 0x7f892D59… EOA n13 (2 signers, so both are needed: one as caller, one by ecrecover)

## Impact and exposure

- Value held at block 26,438,999: $905 (ETH and 49 priced tokens, over 13 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move the funds to a new wallet before any signer account gets real code; long term, a new wallet that accepts code-bearing signers (ERC-1271) or no longer relies on ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
