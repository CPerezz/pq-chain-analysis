---
id: ed2e7178-wallets-fixed-signers
title: "0xed2e7178: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xed2e71780da57d57fe711ab80446439a25485cf4"
  family: "f9f6537239c2cc4c7f5f34a7350c1d72"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "2 of the 3 owners"
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
  note: "Same check as template 8f5fee6f; fixed signer set that can never be replaced → HIGH."
---

## Summary

This is a verified SimpleMultiSig (EIP-712 v2: execute with executor/gasLimit, 0xa0ab9653) with a 2-of-3 owner set fixed at construction. There is no setter, no proxy, and no exit other than execute.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Etherscan: Verified, Contract Name SimpleMultiSig; dispatcher matches template (execute, isOwner, ownersArr, threshold, nonce, DOMAIN_SEPARATOR, type-hash constants); the only runtime SSTORE is the nonce increment
- At 26438999: threshold=2, ownersArr=[0x354bf419e0b910cb0e79e55c097bf9d41b0b88d4 (EOA, nonce 0), 0x4c9950b2cdf6c462f305a8758a7582d92afbfdf4 (EOA, nonce 36), 0x91e6adeb41f1dcc5330ba19c34d4a632cddc45c1 (EOA, nonce 0)], nonce 3; EIP-1967 slots zero
- ETH balance 0 at 26438999; Etherscan 8 transactions
- row: value_usd null, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owners move funds out before 2 of them give their keys code. Otherwise any funds are locked.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
