---
id: nbean-12305d63-signer-upgrade-only
title: "NBean: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x12305d63c66f31395e4e110003fb467ab510c2ee"
  family: "0de6e4242787144afc59a7702be8b9cd"
  name: "NBean"
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
  note: "Refuted: the expected signer already has real code today."
---

## Summary

NBean implementation: the stored signer is this contract's own address (code, 10,465 bytes), which ecrecover can never return, so the whitelist-signature path is already closed today; proxies (0x7b2f8108…) have their own storage.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: NBean checkWhitelistEligibility: the stored signer must sign the caller's address. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- signer() = 0x12305d63…c2ee (itself) at 26438999 (facts getters)
- code at 0x12305d63… = 10,465 bytes (chain1)
- owner() = 0x4890d2473Cb2642cbdC8a70159C3d195BE400Eb6, an EOA (nonce 103)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none needed for this address

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
