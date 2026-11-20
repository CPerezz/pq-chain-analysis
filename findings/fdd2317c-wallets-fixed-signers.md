---
id: fdd2317c-wallets-fixed-signers
title: "0xfdd2317c: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xfdd2317c421f43462b6dc2f9a5a314c769567ad0"
  family: "3e603136d2c5b4ccab55ddce7bacbf9b"
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
- Creation tx 0xc3c0041c1d63a343549a0ffbd012e77c77ee2a3112650b0d7ff3e6284c1b17fa (block 26406924, deployer 0x897f0d12bff9beeb30f05f4aedfc5dbe17702ed0): initcode = bare copy constructor (…5f395ff3fe) with no SSTORE and no constructor args
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
