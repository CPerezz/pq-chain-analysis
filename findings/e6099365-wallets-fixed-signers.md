---
id: e6099365-wallets-fixed-signers
title: "0xe6099365: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xe6099365d67d4230c785d9261a155da74b27a747"
  family: "89c93219aa2169d0f7457be0f52361a3"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "3 of the 5 owners"
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
  note: "Multisig with a fixed signer set that can never be replaced, and execute is the only exit → HIGH (value does not lower it)."
---

## Summary

This is a SimpleMultiSig v2-style rewrite with custom errors and a receive() that emits EthDeposit. execute 0xa0ab9653 needs 3 signatures recovering to owners in ascending order. The 5 owners are fixed at construction; there is no setter and no proxy.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Dispatcher: isOwner, threshold, execute a0ab9653, ownersArr only; the only runtime SSTORE is the nonce increment; EIP-1967 slots zero
- At 26438999: threshold=3, ownersArr=[0x1c2d661d…bdcb, 0x3bfde25b…42cd, 0xba7d68f3…c087, 0xda80812a…7a23, 0xf083e8c8…05df], all EOAs with no code (nonce 0); multisig nonce 0
- ETH balance 0 at 26438999; created block 21643322 (2025-01-17); never executed
- row: value_usd null, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owners move funds out before 3 of them give their keys code. Otherwise any funds are locked.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
