---
id: ac30dcd8-wallets-fixed-signers
title: "0xac30dcd8: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xac30dcd8a68b00dd84d26940a070024b00b3cc1a"
  family: "c272500a72d1ae02a081fdfc636e0b2a"
  copies: 38
  upgradeable: "no"
  rating: HIGH
  value_usd: 394
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the wallet's owners (2 of 3 EOAs)"
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
  note: "Same check as template, fixed owners, no other exit: HIGH."
---

## Summary

A standard SimpleMultiSig v2: execute 0xa0ab9653 needs 2 ecrecover'd owner signatures, and the owners are fixed. 0.2129 ETH is locked once owner keys take code.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- selectors: threshold, execute 0xa0ab9653, ownersArr, nonce; heimdall: isOwner map check on the ecrecover result, executor==0 check; no setter, no proxy slots
- at block 26438999: threshold=2, nonce=4, owners [0x1951a09eafd91f32534692532bb6332512d59bc5, 0x3a563346d1ac485a3ec065f6b08504cc59c7cef0, 0xb55f7af6e2e85d9515d6455d5e02b5290dd2c67c], balance 0.2129 ETH
- cast code latest: all owners EOA (nonces 0/0/466)
- batch row: value_usd 394, txs_90d 0, last_active null, copies 38

## Impact and exposure

- Value held at block 26,438,999: $394 (ETH and 49 priced tokens, over 38 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Final 2-of-3 execute moving the funds to a migratable wallet before key migration.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
