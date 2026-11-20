---
id: a4c96a90-wallets-fixed-signers
title: "0xa4c96a90: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xa4c96a9012a3aa9ca88a25815ca4aab5eb31a279"
  family: "84905537889ab61bbfa72bd1a094057a"
  copies: 2
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
  note: "Owners fixed after creation; signed exits only: HIGH."
---

## Summary

The same extended Ownbit child design as 0x74723d74, with immutable factory 0xf33d99c4…: the owner setter 0x74f9b9e8 is factory-only and used only at creation; every fund path is signed.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0x74f9b9e8 guard compares CALLER with 0xf33d99c4b513b3ea278d873b6fdb1674e24fa16c (bytecode @0x72b/0x734); factory() returns that constant
- Factory 0xf33d… code (latest, unverified): 0x74f9b9e8 is called only right after CREATE2 at 0x243/0x581
- Fork traces: liquidatedAssets, crossChain, spendAny, spendERC20 and toSwap reach ecrecover 2 times; getOwners at block 26438999: 0x083b..a14e, 0x438e..080e, 0x0e92..ec1b, all EOAs (cast code latest)
- No proxy slots; no value measured, 0 txs in 90d

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners sign a spend to a new wallet before their keys gain code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
