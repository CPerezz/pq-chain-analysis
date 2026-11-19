---
id: smartaccountv2-1609cca9-signer-upgrade-only
title: "SmartAccountV2: signer replaceable only by an upgrade"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1609cca90126a4f51b4800418ba5bbd81d4b9ac6"
  family: "775f9f4e73d3d81e75569bdf23921cf7"
  copies: 1515
  name: "SmartAccountV2"
  upgradeable: "no"
  rating: HIGH
  value_usd: 18069
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 8
  last_active: 2026-11-09
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the verification"
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
  verdict: confirmed
  rating: HIGH
  note: "owner fixed in practice; account funds locked if the owner key takes code"
---

## Summary

`SmartAccountV2` at `0x1609cca90126a4f51b4800418ba5bbd81d4b9ac6`, with 1,514 more addresses running its code. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the user operation must be signed by the stored owner / isValidSignature: the recovered address must be an owner. Read from source.
- Update path, read at block 26,438,999: proxy to 0x5147ce3947a407c95687131be01a2b8d55fd0a40: no admin, no upgrade function in the implementation.
- Source read: a user operation and isValidSignature must recover to the stored owner.
- The 1,515 addresses are slot-0 proxies to 0x5147ce3947a407c95687131be01a2b8d55fd0a40, whose code has no upgrade function and no owner setter among its named functions, so the owner is fixed in practice.
- 8 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $18,069 (ETH and 49 priced tokens, over 1,515 addresses).
- Activity: 8 transactions called it in the 90 days before that block; last on 2026-11-09.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
