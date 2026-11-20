---
id: 6a40efe7-signer-upgrade-only
title: "0x6a40efe7: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x6a40efe72c9d51188604b4d83724fd3baf7d3589"
  family: "817e7fe45f0bd4d5932741d1f048a8c2"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
evidence:
  level: executed
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
  note: "Refuted: the address is an implementation whose initializers are disabled and whose signer is unset."
---

## Summary

Uninitialized implementation contract (one stored verifier): its own storage has no signer, owner or funds; proxies that run it keep their own state and upgrade path and are rated as their own rows.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: one stored verifier behind a proxy; no setter name seen. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- slot 0 = 0xff (OZ4 _initialized = 255, initializers disabled) at 26438999 (chain1)
- owner() returns zero or reverts at 26438999; EIP-1967 implementation and admin slots are empty (chain1)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none needed for this address

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
