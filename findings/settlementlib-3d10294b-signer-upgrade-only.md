---
id: settlementlib-3d10294b-signer-upgrade-only
title: "SettlementLib: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x3d10294b8cebdd880afcc6d96e77cf5c5f32679d"
  family: "b2f50875af2fc88a528d6da76abe682b"
  copies: 3
  name: "SettlementLib"
  upgradeable: "no"
  rating: NONE
  txs_90d: 2
  last_active: 2026-10-04
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

SettlementLib is an external library: its code reads the calling contract's storage, and the signer comes from the caller, which manages it. The library itself holds no state and no funds.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: SettlementLib verifyOracle: confirmations of stored oracles. Read (function text).
- Update path, read at block 26,438,999: delegates to a fixed address.
- The bytecode starts with the library or self-address guard (PUSH20/PUSH32 of its own address) (dossier code.hex)
- The signer is passed in by the caller or read from the caller's storage (source or decompile)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-10-04.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
