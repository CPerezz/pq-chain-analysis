---
id: 3cd540c2-wallets-fixed-signers
title: "0x3cd540c2: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x3cd540c2d08cfda0ce465c33073d2fd103c7615e"
  family: "dbb576434edccedf0ef4a6e37a3499f4"
  copies: 2
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "owners (2-of-N) via a signed self-call"
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
  verdict: refuted
  rating: NONE
  note: "Refuted per scale: key is settable (by the owners' own signed self-call), so the root issue is rotate-signer-before-migrating. Batch row: value_usd null, txs_90d 0, last_active null."
---

## Summary

SimpleMultiSig variant with setOwners(uint256,address[]) (0xf3182e85) callable when msg.sender == address(this), i.e. through a threshold-signed execute to itself; the signer set is replaceable.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Strings/decompile: setOwners requires 'Sender must be this contract', rewrites owners and threshold
- At 26438999: threshold 2, nonce 0, ownersArr = 0x0afc581a…30b7, 0x101e9536…8d77, 0x11fa9ff4…3a37
- Balance 0; EIP-1967 implementation slot empty
- All three owners have no code (publicnode, latest, block ~26452934)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners rotate to new keys via execute→setOwners before their accounts take code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
