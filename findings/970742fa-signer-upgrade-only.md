---
id: 970742fa-signer-upgrade-only
title: "0x970742fa: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x970742fadfab60fa79ca79bd37f5e7ee2778dde5"
  family: "a5ac3482130fe2c9947a834887839c98"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Rule: an uninitialized (or initializer-disabled) implementation is refuted. Not checked: which proxies point to it."
---

## Summary

unverified (heimdall decompile): this address is a logic/implementation contract, never initialized: owner and the signer storage are empty, holding no ETH; it has no signer of its own, so nothing here depends on a stored key. Same SlickSwapV1 selector set (setNextOwner, both upgrade forms): the key is settable and every signed act has a direct-call twin.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgrade). Placed by a rule; copy of template ee56db4b, not read on its own.
- Update path, read at block 26,438,999: upgrade((uint8,bytes32,bytes32,uint96)), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- block 26438999 (read before the node saturated): owner()=NA, EIP-1967 admin slot=0, slot0=0x0000000000000000000000000000000000000000000000000000000000000000, OZv5 initializer slot low bytes=0000000000000000, ETH balance=0.000000000000000000
- Upgrade selectors present: upgrade((uint8,bytes32,bytes32,uint96)),upgrade(); the batch 'owner zero' is expected for an implementation
- Source/decompile: unverified (heimdall decompile); txs_90d=0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for this address. Any proxies running this code are separate rows; they are upgradeable by their own owner/admin (UUPS).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
