---
id: 0aac24e7-wallets-fixed-signers
title: "0x0aac24e7: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x0aac24e7cb56ad3f4078b047af106d8bfb201faf"
  family: "c986ee03445d9d43cef9444ae539d1c3"
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
  note: "1-of-1 SimpleMultiSig -- same owner-funds-locked mechanism as the N-of-M template -> HIGH"
---

## Summary

SimpleMultiSig v2.0.1 exact copy; single owner, threshold=1 (an EOA-gated wallet enforced via signature rather than msg.sender). No setter, no proxy; owner is still an EOA.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dispatcher selectors match template 8f5fee6f exactly (NAME_HASH/VERSION_HASH/TXTYPE_HASH/EIP712DOMAINTYPE_HASH/SALT/execute/getOwners/isOwner/threshold/domainSeparator)
- getOwners()=[0x028ce9793123344cde592f393b96a8368c1b0abb], threshold()=1 (scanner read, block 26438999)
- eth_getCode on publicnode (latest, block ~26488250) for the owner = 0x (EOA)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

owner must migrate funds to a new wallet before taking code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
