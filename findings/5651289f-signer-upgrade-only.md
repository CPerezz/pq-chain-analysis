---
id: 5651289f-signer-upgrade-only
title: "0x5651289f: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5651289f4b55a4e1c813839b09c857f2efc1e2b2"
  family: "be19aac4f9101c77c99773eaa29cbf22"
  copies: 650
  upgradeable: "yes"
  admin: "0xc1acf4a7e6198403e0f4f8ac86c145dc50b352e1"
  rating: LOW
  value_usd: 26603
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 564
  last_active: 2026-11-18
fix:
  layer: contract-upgrade
  who_acts: "EOA owner 0xc1acf4a7…"
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
- Update path, read at block 26,438,999: proxy to 0x8df6945c5b70b7c7c1a0a95fd38c26963bb8915a with upgradeTo(address), owner 0xc1acf4a7e6198403e0f4f8ac86c145dc50b352e1.
- owner() at 26438999 = 0xc1acf4a7e6198403e0f4f8ac86c145dc50b352e1
- that address has no code and nonce 3368 at 26438999 (active EOA)

## Impact and exposure

- Value held at block 26,438,999: $26,603 (ETH and 49 priced tokens, over 650 addresses).
- Activity: 564 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Owner calls upgradeTo with a new implementation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
