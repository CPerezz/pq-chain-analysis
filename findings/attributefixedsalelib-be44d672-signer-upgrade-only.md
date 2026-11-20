---
id: attributefixedsalelib-be44d672-signer-upgrade-only
title: "AttributeFixedSaleLib: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xbe44d672aacc9d87c636e5eedbb7d2e957fe1e25"
  family: "8ccef3f09da775b84b62dddf217f10bf"
  copies: 2
  name: "AttributeFixedSaleLib"
  upgradeable: "no"
  rating: NONE
  txs_90d: 1
  last_active: 2026-09-02
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

AttributeFixedSaleLib is an external library: its code reads the calling contract's storage, and the signer comes from the caller, which manages it. The library itself holds no state and no funds.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read (function text).
- Update path, read at block 26,438,999: delegates to a fixed address. 1 with an upgrade function whose caller was not read.
- The bytecode starts with the library or self-address guard (PUSH20/PUSH32 of its own address) (dossier code.hex)
- The signer is passed in by the caller or read from the caller's storage (source or decompile)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-02.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
