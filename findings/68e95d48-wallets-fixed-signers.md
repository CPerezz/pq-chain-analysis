---
id: 68e95d48-wallets-fixed-signers
title: "0x68e95d48: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x68e95d48f6983d0620c280162d2a8234fa608acd"
  family: "a3e6f0be985b586f02b8dd2380257ca5"
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
  note: "Fixed owners; all fund paths signed: HIGH."
---

## Summary

A Fintoch-flavoured Ownbit multisig (2-of-3): spend, spendERC20, spendAny and a signed 0x15964862 that calls redemption(address,uint256) on an external contract. No owner setter.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Four runtime SSTOREs, all the slot-3 nonce (one per signed function)
- Fork traces: 0x15964862, spendERC20 and spendAny each reach ecrecover 2 times with 2 signatures
- getOwners at block 26438999: 0x8bdd..91db, 0x62b8..5957, 0x612a..837a; all EOAs (cast code latest)
- No proxy slots; no value measured, 0 txs in 90d

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners sign a spend to a new wallet with replaceable signers before their keys gain code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
