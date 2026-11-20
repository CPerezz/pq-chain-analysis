---
id: 8c401a03-signer-upgrade-only
title: "0x8c401a03: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8c401a037f083f769334b7c841d9c417d71db263"
  family: "55094f8d1564c69bb4037111d7751418"
  copies: 1089
  upgradeable: "yes"
  admin: "0xddd6c26449617db919519cd6b39a16f28a855231"
  rating: LOW
  value_usd: 85723
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 104
  last_active: 2026-11-11
fix:
  layer: contract-upgrade
  who_acts: "EOA owner 0xddd6c264…"
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
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Live owner EOA: LOW."
---

## Summary

Stored-key contract behind a UUPS proxy; the signer has no setter but the implementation can be replaced.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0x134ede251322ac66ceaf97dddc0031b2f59f5b88 with upgradeTo(address), owner 0xddd6c26449617db919519cd6b39a16f28a855231.
- owner() at 26438999 = 0xddd6c26449617db919519cd6b39a16f28a855231
- that address has no code and nonce 5835 at 26438999 (active EOA)

## Impact and exposure

- Value held at block 26,438,999: $85,723 (ETH and 49 priced tokens, over 1,089 addresses).
- Activity: 104 transactions called it in the 90 days before that block; last on 2026-11-11.

## Remediation

Owner calls upgradeTo with a new implementation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
