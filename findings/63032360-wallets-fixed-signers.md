---
id: 63032360-wallets-fixed-signers
title: "0x63032360: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x630323602efa998792ca8de47143e29d34998325"
  family: "0ce76a69214462f0ef871ee6e79248d8"
  copies: 2
  upgradeable: "no"
  rating: HIGH
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-18
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
  note: "borrowInfo/crossChain/toSwap are signed and don't touch owners; no unsigned exit: HIGH."
---

## Summary

An extended Ownbit multisig (2-of-3) with spend, spendERC20, spendAny, crossChain, toSwap and setBorrowInfo(string,uint256,address,v[],r[],s[]). Every state-changing function is signature-gated, and none rewrites owners.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Runtime SSTOREs: the slot-5 nonce in each signed function, plus the borrowInfo struct written by setBorrowInfo; nothing writes the owners array (slot 4) or required
- Fork traces with 2 signatures: crossChain, spendAny, spendERC20, toSwap and setBorrowInfo all reach ecrecover 2 times; with 1 signature they revert first
- getOwners at block 26438999: 0xa3e1..e69d, 0x18cf..c7a6, 0x89e8..643e; all EOAs (cast code latest)
- No proxy slots; value $1, 0 txs in 90d

## Impact and exposure

- Value held at block 26,438,999: $1 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners sign a spend to a new wallet with replaceable signers before any key gains code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
