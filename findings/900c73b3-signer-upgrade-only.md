---
id: 900c73b3-signer-upgrade-only
title: "0x900c73b3 (tagged deployed by NatGold: Deployer): signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x900c73b3cad6520bd2042d5a53a622afb31c513f"
  family: "e647cdafb95b959e0acc41cbbfc94cd3"
  copies: 2
  label: "deployed by NatGold: Deployer"
  upgradeable: "yes"
  admin: "owner Safe 0x3c1363c0… (3 of 5)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "owner Safe 0x3c1363c0… (3 of 5)"
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
  note: "Safe owner can upgrade"
---

## Summary

contract: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Placed by a rule; copy of template ee56db4b, not read on its own.
- Update path, read at block 26,438,999: proxy to 0x73e22397bc905bc3bcf4796083925633bedee215 with UPGRADE_INTERFACE_VERSION(), owner 0x3c1363c020baaf863590e62fbdd5330864016b63.
- UUPS proxy, impl 0x73e22397…; eth_call upgradeToAndCall from the Safe succeeds at block 26438999
- owner 0x3c1363c0… is a Safe: getThreshold 3, getOwners 5
- txs_90d=0, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

the upgrade holder deploys an implementation whose signer check accepts the new key (or ERC-1271) and upgrades before the signer gains real code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
