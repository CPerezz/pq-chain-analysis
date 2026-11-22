---
id: 00071196-signer-upgrade-only
title: "0x00071196: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x00071196a9129b7068404523e2047ef79f4ed0de"
  family: "59acd03e025b42881815a4ed3d02d671"
  upgradeable: "yes"
  admin: "0x7f4cba3d7f20bf5146e4e5f8929b676ca05a5545"
  rating: LOW
  txs_90d: 13317
  last_active: 2026-10-15
fix:
  layer: contract-upgrade
  who_acts: "EOA admin 0x7f4cba3d…"
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
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Live admin EOA: LOW."
---

## Summary

Stored-key-set contract (copy of template 35075ad3) behind a proxy; replaced through an upgrade, not a setter.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Placed by a rule; copy of template 35075ad3, not read on its own.
- Update path, read at block 26,438,999: proxy to 0x6859b2ae7ce9fb0c4faa71798ac5498b41b42d7a, admin 0x7f4cba3d7f20bf5146e4e5f8929b676ca05a5545.
- EIP-1967 admin slot at 26438999 = 0x7f4cba3d7f20bf5146e4e5f8929b676ca05a5545
- that admin has no code and nonce 31 at 26438999 (active EOA)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 13,317 transactions called it in the 90 days before that block; last on 2026-10-15.

## Remediation

Admin calls upgradeTo/upgradeToAndCall.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
