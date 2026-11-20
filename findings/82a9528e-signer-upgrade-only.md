---
id: 82a9528e-signer-upgrade-only
title: "0x82a9528e: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x82a9528ef49b95d4364741b96ced566b11715a1a"
  family: "498b59b6a1d4e7dfa2f41a0d4560014f"
  copies: 2
  upgradeable: "no"
  rating: NONE
  txs_90d: 1
  last_active: 2026-11-04
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
  note: "library; the affected contracts are its callers, separate addresses"
---

## Summary

This contract (bytecode 0x73<self>…) is an external library: its code reads the calling contract's storage, and the signer comes from the caller, which manages it. The library itself holds no state and no funds.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- The bytecode starts with the library or self-address guard (PUSH20/PUSH32 of its own address) (dossier code.hex)
- The signer is passed in by the caller or read from the caller's storage (source or decompile)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-11-04.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
