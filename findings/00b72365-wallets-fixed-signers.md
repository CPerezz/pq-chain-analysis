---
id: 00b72365-wallets-fixed-signers
title: "0x00b72365: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x00b7236575162e7ab49e86b9ba86906e6e0f60a1"
  family: "a8a09d43d8bf7632efa3d3791bbd0a72"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "none"
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
  note: "fixed 4-owner/3-threshold wallet, no update path -> HIGH"
---

## Summary

SimpleMultiSig variant (adds a permitMessage domain-separator helper) but runs the exact same execute/ownersArr/threshold/nonce signature check as the template. 4 fixed owners, threshold=3, no setter, no proxy; all 4 owners still EOAs.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dispatcher: permitMessage/threshold/execute(uint8[],bytes32[],bytes32[],address,uint256,bytes,address,uint256)/ownersArr/nonce/getDomainSeparator
- ownersArr(0..3) via publicnode eth_call (latest) = 0x3c7812f87709f2aed7b9a09332a3ac1b4b81e00c,0x4cea53726b72e55236ae57e40a7edd697c1746e5,0x6d597cdbfce6ab1b4344ceddc67e220f821045a7,0x6e8891a315d1dbdb76828d0e2230b8108a53fa4d
- threshold()=3 (scanner read, block 26438999)
- eth_getCode on publicnode (latest, block ~26488250) for all 4 owners = 0x (EOA)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

owners must migrate funds before any owner takes code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
