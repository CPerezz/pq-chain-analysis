---
id: 2920eb36-signer-upgrade-only
title: "0x2920eb36 (tagged deployed by NatGold: Deployer): signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2920eb363819f5ad52819c799da609733455a6c8"
  family: "cfa82d3ecc4200fa7888805217cf2df1"
  copies: 3
  label: "deployed by NatGold: Deployer"
  upgradeable: "yes"
  admin: "0xacda9dba1c1863ec128b362ca26d288ec9196e6d"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0x0a01fbf6c343a61f1959437ed4d5733bf0135178 with UPGRADE_INTERFACE_VERSION(), owner 0xacda9dba1c1863ec128b362ca26d288ec9196e6d)"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025)"
---

## Summary

Contract `0x2920eb363819f5ad52819c799da609733455a6c8` (Etherscan tag: deployed by NatGold: Deployer), with 2 more addresses running its code. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Placed by a rule; copy of template ee56db4b, not read on its own.
- Update path, read at block 26,438,999: proxy to 0x0a01fbf6c343a61f1959437ed4d5733bf0135178 with UPGRADE_INTERFACE_VERSION(), owner 0xacda9dba1c1863ec128b362ca26d288ec9196e6d.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
