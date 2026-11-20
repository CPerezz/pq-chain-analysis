---
id: 8730b06b-wallets-fixed-signers
title: "0x8730b06b: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x8730b06bf9f73acdd4c18723c58ad978579c1a37"
  family: "1c777770105172c66f1cf867bdd67ce3"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "the 3 owners (2-of-3)"
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
  note: "Fixed signer set, ecrecover is the only exit; owners' own funds locked once keys take code (HIGH by mechanism, $0 now)."
---

## Summary

SimpleMultiSig v2 variant (EIP-712 execute with executor/gasLimit, getOwners): every signature must recover to an owner in ascending order; owners fixed at construction, no setter, no proxy.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Dispatcher: threshold, isOwner, execute(0xa0ab9653), getOwners, nonce, EIP-712 constants only; no setter/upgrade selector (sels.txt, heimdall)
- At 26438999: getOwners = 0x354b…88d4, 0x4c99…fdf4, 0x91e6…45c1; threshold 2; nonce 1; ETH balance 0; EIP-1967 impl slot 0
- All 3 owners have no code today (EOAs; nonces 0/36/0) (latest, block ~26452900, publicnode)
- row: value_usd null, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move funds out with 2-of-3 signatures before converting their keys to code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
