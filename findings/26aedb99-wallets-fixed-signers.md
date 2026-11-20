---
id: 26aedb99-wallets-fixed-signers
title: "0x26aedb99: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x26aedb99b40466bd5d79d8589898db5e05daa827"
  family: "b1a23d141e0499d879dff6f093fc57a0"
  copies: 50
  upgradeable: "no"
  rating: HIGH
  value_usd: 3856
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
  note: "No update path, and the fixed signers' signatures are the only way to move the wallet's own funds (moving funds out before migrating is a migration step, not a way out): HIGH. Value $3856, txs_90d 0; value does not lower the rating."
---

## Summary

A minimal forwarding proxy to 0x3fcc636d…, an old BitGo WalletSimple (sendMultiSig with expiry, createForwarder, destinationAddress). The signers live in the clone's storage, written by its creation code; no runtime function rewrites them.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: 50 wallets in the BitGo pattern. Bytecode and names.
- Update path, read at block 26,438,999: delegates to a fixed address.
- 47-byte forwarding proxy (CALLDATACOPY; DELEGATECALL to a hard-coded implementation with gas-50; returns 32 bytes): no proxy slots, no upgrade; target 0x3fcc636dedf7df6357b552076df837667c62e6ae (2053 bytes)
- Implementation decompiled (heimdall, scratch 051-wallets-fixed-signers/0x3fcc…): sends need a signer caller plus an ecrecovered signer ≠ caller; runtime SSTOREs only on slot 1 (safeMode), slot 2 (sequence id) and the forwarder initcode; no init function, no SELFDESTRUCT; ecrecover is called with gas-minus-constant (not a fixed stipend)
- signers() via the clone at 26438999: 0xd89BB303… EOA n0, 0x0909FBDf… EOA n0, 0xb1790627… EOA n61; safeMode false

## Impact and exposure

- Value held at block 26,438,999: $3,856 (ETH and 49 priced tokens, over 50 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move the funds to a new wallet before any signer account gets real code; long term, a new wallet that accepts code-bearing signers (ERC-1271) or no longer relies on ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
