---
id: 973e8678-wallets-fixed-signers
title: "0x973e8678: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x973e86786a978c92884125a457eae427c8b3ee22"
  family: "ea388d1aec10bc92f532225d51e60b5e"
  copies: 2
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "the 7 owners (3-of-7)"
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
  note: "Fixed signer set; owners' own funds locked once keys take code (HIGH by mechanism; never used, nonce 0)."
---

## Summary

SimpleMultiSig v2 variant (EIP-712 execute with executor/gasLimit, getOwners): owners fixed at construction, no setter, no proxy; signatures are the only exit.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Dispatcher: isOwner, threshold, execute(0xa0ab9653), getOwners, nonce, domainSeparator + EIP-712 constants only (sels.txt, heimdall)
- At 26438999: 7 owners (0x6c3a…, 0x81e1…, 0x9edf…, 0xb727…, 0xbf5f…, 0xc1c4…, 0xed38…), threshold 3, nonce 0; ETH 0; EIP-1967 slot 0
- All 7 owners have no code today (EOAs, nonce 0) (latest, block ~26452900, publicnode)
- row: value_usd null, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move funds out with 3 signatures before converting keys to code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
