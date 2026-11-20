---
id: 3ec6cdcc-wallets-fixed-signers
title: "0x3ec6cdcc: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x3ec6cdccd2f86d6058d901f86f1f5d518b1a8c31"
  family: "e0b92c9f44db783336e2db004481e967"
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
  note: "Fixed owners, no setter or upgrade, signed transfer is the only exit: HIGH (rated by mechanism; it holds nothing today)."
---

## Summary

Not Ownbit: the same tranCoin/isOwner/nonce multisig family as 0xb96b4c37 (2-of-3). Owners are set in the constructor only, and tranCoin (ecrecover) is the only exit.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Dispatcher: tranCoin (0x22023bd7), isOwner, nonce; a single SSTORE (nonce)
- Creation tx 0x579a49bc… (Blockscout): owners [0x13053298…5b7, 0xd10ee808…6da, 0x65605bc6…a7a], required 2; isOwner true for all (latest, block ~26452900)
- All three signers are EOAs (latest via publicnode, block ~26452900)
- No proxy slots; holds 0 ETH; no value measured, never used (nonce 0)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move any funds out with tranCoin before the keys gain code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
