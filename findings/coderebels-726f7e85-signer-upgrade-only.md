---
id: coderebels-726f7e85-signer-upgrade-only
title: "CodeRebels: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x726f7e8542459a7d0036c7c3d970b3eb79bf376c"
  family: "4ad791cd2506fea2438e0ebc37277434"
  name: "CodeRebels"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
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
  note: "Refuted per the main reviewer's rule (2026-11-20): an implementation with no live proxy found and no state of its own. Its own ETH balance could not be read (node timeout); the proxy search was stopped to spare the node."
---

## Summary

Uninitialized implementation (initializers disabled, owner zero). The constant signer reaches only proxies that run this code, and no such proxy was found; the address holds no signer state of its own.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: returns the recovered address, or compares it with an address its caller passes in / CodeRebels verifyX: a constant address (0x55fd…872A) must sign the caller. Read (function text).
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- slot 0 = 0xff (OZ4 _initialized = 255, initializers disabled) at 26438999 (chain1)
- constructor calls _disableInitializers() (CodeRebels.sol:28-29)
- verifyX signer is a constant address 0x55fd…872A (row note)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none needed for this address

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
