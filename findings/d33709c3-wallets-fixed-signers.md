---
id: d33709c3-wallets-fixed-signers
title: "0xd33709c3: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xd33709c334664382cd5c6dcac9f0d85f2e8593d2"
  family: "594ad61fff2b3f4bdf9b3b51a2d1c819"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
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
  verdict: refuted
  rating: NONE
  note: "Uninitialized implementation: no signer exists at this address, and every path to the check reverts → refuted."
---

## Summary

This is not SimpleMultiSig. It is an unverified 2-function logic module (1e7ed7f9 returns the constant 2; 0xfb76f9d4 is a signed bridge/settlement batch) whose storage layout (chain id slot 0, records, signer mapping slot 4, fee config 0x12) is meant to be used through delegatecall. Here the constructor wrote nothing, so the signer set is empty and the 2-signature check can never pass.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Creation tx 0x201f39ced4cca273758bca3f94e7d365ecb21536e9f581b321b3c9d8cdc3e05f (block 26108042, deployer 0x550d6b73c17e9a32fa275aeafe155d6d228dad00): initcode = bare copy constructor (…5f395ff3fe) with no SSTORE and no constructor args
- Disassembly: the only SSTOREs come after the EIP-712 digest + ≥2-signature check (signer must be in mapping slot 4, strictly ascending, OZ ECDSA s-check); no setter, no other selector
- Storage slots 0,3,5,6,7,9,0x10,0x12,0x13 all zero (latest via publicnode; contract nonce 1, 0 txs, so unchanged since 26438999); ETH balance 0 at 26438999
- row: value_usd null, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for this address. Judge the proxy/router that delegatecalls this module (its signers and admin) on its own.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
