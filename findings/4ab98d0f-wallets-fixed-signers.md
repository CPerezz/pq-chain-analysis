---
id: 4ab98d0f-wallets-fixed-signers
title: "0x4ab98d0f: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x4ab98d0f5bac73ceb543ddf4a23d5ebca75b2d0f"
  family: "eb9e8fa4853bc643f08ca6ede020e083"
  copies: 15
  upgradeable: "no"
  rating: HIGH
  value_usd: 1418
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-10-22
fix:
  layer: account-migration
  who_acts: "wallet owners"
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
  note: "No upgrade path and no setter; spend with ecrecovered owner signatures is the only exit, so HIGH."
---

## Summary

OwnbitMultiSig (verified on Sourcify): spend() needs getRequiredWithoutInactive() distinct ecrecovered owners and no function changes owners or required. If owners' accounts get real code, the wallet's funds can't move.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Sourcify exact source OwnbitMultiSig.sol: owners/required set only in the constructor; the only runtime writes are active() (owner timestamp) and spendNonce
- _validSignature: ecrecover per signature, then _distinctOwners; inactive owners only lower the threshold, never below 1 signature
- getOwners at block 26438999: 0x49dd..cf22, 0xc426..3977, 0xcf21..faaa (required 2); all three EOAs (cast code latest, block ~26452838)
- No EIP-1967 implementation or admin slot (block 26438999); value $1418, 6 txs in 90d, last active 2026-10-22

## Impact and exposure

- Value held at block 26,438,999: $1,418 (ETH and 49 priced tokens, over 15 addresses).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-10-22.

## Remediation

Owners sign a spend that moves the funds to a wallet with replaceable signers before their keys gain code (EOA and 7702-delegated signers keep recovering).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
