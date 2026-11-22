---
id: ff04af64-signer-upgrade-only
title: "0xff04af64: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xff04af64385973bc3697fa17949a0b2a9b437fc9"
  family: "f6630b11cdec712355dfcd9b5a7f5ea0"
  copies: 626
  upgradeable: "yes"
  admin: "owner 0xd6150F8b… (EOA, nonce 2430)"
  rating: LOW
  value_usd: 17
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "owner 0xd6150F8b… (EOA, nonce 2430)"
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
  note: "live EOA owner can upgrade"
---

## Summary

contract: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0x4802779e9ef5543a8d976e83d0a3f7c5ee09f480 with UPGRADE_INTERFACE_VERSION(), owner 0xd6150f8b9e586fbc36f498ff9a1d50525e406fa8.
- UUPS proxy, impl 0x4802779e…; eth_call upgradeToAndCall from the owner succeeds
- owner has no code, nonce 2430
- txs_90d=0, value_usd=17

## Impact and exposure

- Value held at block 26,438,999: $17 (ETH and 49 priced tokens, over 626 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

the upgrade holder deploys an implementation whose signer check accepts the new key (or ERC-1271) and upgrades before the signer gains real code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
