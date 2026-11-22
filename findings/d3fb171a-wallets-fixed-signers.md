---
id: d3fb171a-wallets-fixed-signers
title: "0xd3fb171a: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd3fb171ae872b574576549ef6df5d17af835b923"
  family: "061df104cc3eecad87e474393ac92be0"
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
  note: "No setter, no unsigned exit, no upgrade: HIGH."
---

## Summary

The same extended Ownbit design as 0x63032360 (bytecode differs slightly): spend, spendERC20, spendAny, crossChain, toSwap and setBorrowInfo are all signed; owners fixed.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- SSTOREs only to the slot-5 nonce and the borrowInfo struct; no owner or required write
- Fork traces: crossChain, spendAny, spendERC20, toSwap and setBorrowInfo each reach ecrecover 2 times with 2 signatures
- getOwners at block 26438999: 0x8f16..ae55, 0x9d5d..1df6, 0x6f98..4572; all EOAs (cast code latest)
- No proxy slots; value $1, 0 txs in 90d

## Impact and exposure

- Value held at block 26,438,999: $1 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners sign a spend to a new wallet with replaceable signers before any key gains code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
