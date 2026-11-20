---
id: 74723d74-wallets-fixed-signers
title: "0x74723d74: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x74723d741f2d5e2e9d2a1d83e22a943d03647ce0"
  family: "7ddf1d99493bbe33ef4f710544c67c2d"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "wallet owners"
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
  note: "The owner setter is reachable only by the factory at creation, so owners are fixed afterwards; all fund paths signed: HIGH."
---

## Summary

An extended Ownbit child wallet (2-of-3) with signed spend/spendERC20/spendAny/crossChain/toSwap/liquidatedAssets/setBorrowInfo and an owner setter 0x74f9b9e8 that only its immutable factory 0x23891d24… can call. The factory calls it only on the address it just created with CREATE2.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0x74f9b9e8 writes the owners array (slot 4), the owner flags and required (slot 5) after require(msg.sender == 0x23891d24e2b9b21c98c61e6e76496b8757e96de2) (bytecode @0x8ad)
- Factory 0x2389… code (latest, unverified): selector 0x74f9b9e8 is used only right after CREATE2 at 0x27e/0x64f, on the new address
- Fork traces: liquidatedAssets, crossChain, spendAny, spendERC20 and toSwap reach ecrecover 2 times; getOwners at block 26438999: 0x9e74..5081, 0xda23..45db, 0x1c81..b869, all EOAs (cast code latest)
- No proxy slots; no value measured, 0 txs in 90d

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners sign a spend to a new wallet before their keys gain code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
