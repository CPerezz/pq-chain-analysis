---
id: e48cdb8c-signer-upgrade-only
title: "0xe48cdb8c: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xe48cdb8c2e9a90cff77ce4814f0ef483b80f5e2c"
  family: "9bf2014382c1408c07e7b183e18a7c83"
  copies: 2
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: bytecode
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
  note: "Uninitialized: nothing held and no signer set. Owners would be chosen at setup."
---

## Summary

Multisig wallet implementation (owners mapping, threshold, nonce, checkpoint) whose only proxy, 0x2cbc8d10…, was never set up: no signer set exists to be locked.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Proxy 0x2cbc8d10… at 26438999: impl slot = 0xe48cdb8c, admin slot 0, slots 0-2 zero (slot 2 is the 0x64bced84 getter, = 10 on the initialized sibling proxy 0xbc29c0d3…), nonce() = 0, balance 0
- Family 9bf2014382 facts: 2 addresses run the code (this impl and that proxy)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
