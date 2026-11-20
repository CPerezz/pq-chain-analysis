---
id: 598d8138-wallets-fixed-signers
title: "0x598d8138: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x598d8138b0a73211c3ea04d4bf16b3673e9c86aa"
  family: "81aaf2dff78aad1d4d6c4bcb6fce7a04"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the three owners (move funds out before migrating keys)"
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
  note: "HIGH: fixed 2-of-3 signer set with no setter, upgrade or other exit; the owners' funds move only via their signatures. Holds 0 ETH but value never lowers the rating. Batch row: value_usd null, txs_90d 0, last_active null."
---

## Summary

Real SimpleMultiSig v2 (EIP-712): execute(uint8[],bytes32[],bytes32[],address,uint256,bytes,address,uint256) needs 2 signatures recovering to owners in ascending order; owners fixed at construction, no setter or other exit. Signatures from an owner whose account gets code stop recovering.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- getOwners() at 26438999 = 0x354bf419…88d4, 0x4c9950b2…fdf4, 0x91e6adeb…45c1; threshold() = 2; nonce() = 1 (used once)
- All three owners have no code today (cast code 0x on reth, latest); nonces 0, 36, 0
- Selectors: execute 0xa0ab9653, getOwners, isOwner, threshold, nonce, DOMAIN_SEPARATOR; no setter; decompile: ecrecover result must be isOwner and > previous
- Balance 0 ETH at 26438999; EIP-1967 slots empty

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move any assets out before two of them migrate keys to code; afterwards a new multisig with replaceable signers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
