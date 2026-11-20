---
id: 8df6945c-signer-upgrade-only
title: "0x8df6945c: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8df6945c5b70b7c7c1a0a95fd38c26963bb8915a"
  family: "be19aac4f9101c77c99773eaa29cbf22"
  upgradeable: "yes"
  admin: "the account's owner EOA 0xC1aCf4A7e6198403e0F4F8ac86c145DC50B352e1"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the account owner (EOA)"
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
  rating: LOW
  note: "Live, highly active EOA owner with an UUPS upgrade function — LOW."
---

## Summary

Same SimpleAccount/UUPS family as 0x8abb1336...; this proxy's owner is a very active EOA.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- node, block 26438999: proxy 0x5651289f4b55a4e1c813839b09c857f2efc1e2b2, owner() = 0xC1aCf4A7e6198403e0F4F8ac86c145DC50B352e1, nonce = 3368, balance 1.078 ETH — clearly live
- batch facts: upgrades=[upgradeTo(address), upgradeToAndCall(address,bytes), ...]

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls upgradeTo.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
