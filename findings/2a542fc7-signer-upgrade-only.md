---
id: 2a542fc7-signer-upgrade-only
title: "0x2a542fc7: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2a542fc719b628536de6ef9320df3636c12e0443"
  family: "3684f19f3d2d0abd0de08662be1dd493"
  copies: 15
  upgradeable: "yes"
  admin: "owner 0xaE8f94D4… (EOA, nonce 26)"
  rating: LOW
  value_usd: 329
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "owner 0xaE8f94D4… (EOA, nonce 26)"
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
  note: "live EOA owner can upgrade (owner differs from the row)"
---

## Summary

contract: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Placed by a rule; copy of template 5d883d1a, not read on its own.
- Update path, read at block 26,438,999: proxy to 0x27e29ab8e7558a020434c95079b4aac4b58445f1 with UPGRADE_INTERFACE_VERSION(), owner 0x708f741b5fa76c9f4a70355207b4f0226ce265f3.
- UUPS proxy, impl 0x27e29ab8…; eth_call upgradeToAndCall from the owner succeeds
- owner() at the block is 0xaE8f94D4…, not the row's 0x708f741b…; it has no code, nonce 26
- txs_90d=0, value_usd=329

## Impact and exposure

- Value held at block 26,438,999: $329 (ETH and 49 priced tokens, over 15 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

the upgrade holder deploys an implementation whose signer check accepts the new key (or ERC-1271) and upgrades before the signer gains real code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
