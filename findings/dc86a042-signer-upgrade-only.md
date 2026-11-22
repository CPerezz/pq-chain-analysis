---
id: dc86a042-signer-upgrade-only
title: "0xdc86a042: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdc86a042e7a49b60ec1022ec2169b62cc2750457"
  family: "031b0c48bd02916616fe322d7ac36b98"
  upgradeable: "yes"
  admin: "owner 0x80922Fd8… (EOA, nonce 69)"
  rating: LOW
  txs_90d: 1
  last_active: 2026-09-22
fix:
  layer: contract-upgrade
  who_acts: "owner 0x80922Fd8… (EOA, nonce 69)"
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
  note: "live EOA owner can upgrade"
---

## Summary

contract: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Placed by a rule; copy of template 35075ad3, not read on its own.
- Update path, read at block 26,438,999: proxy to 0x8b69f1cd6b36e98e3df50417e5c08ab66bdbb19c with UPGRADE_INTERFACE_VERSION(), owner 0x80922fd8cdc39ad594c1dac15f36d0aaafe6d47f.
- UUPS proxy, impl 0x8b69f1cd…; eth_call upgradeToAndCall from the owner succeeds
- owner has no code, nonce 69
- txs_90d=1, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-22.

## Remediation

the upgrade holder deploys an implementation whose signer check accepts the new key (or ERC-1271) and upgrades before the signer gains real code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
