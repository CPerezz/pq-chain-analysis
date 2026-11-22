---
id: dbd7fbe5-signer-upgrade-only
title: "0xdbd7fbe5 (tagged deployed by Pimlico: ERC-4337 Bundler 203): signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdbd7fbe5b7cd56f99c059dc24052009d2626125c"
  family: "dfc4fa3417721fd3df0a42db6edd011f"
  label: "deployed by Pimlico: ERC-4337 Bundler 203"
  upgradeable: "yes"
  admin: "0x95c28530c33c7297d6ba92177a3b82575ff0dfa3"
  rating: LOW
  txs_90d: 179
  last_active: 2026-11-17
  recoveries_14d: 113
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0x847baa23f56eb3759f3fa623827dc3978eb42657 with UPGRADE_INTERFACE_VERSION(), owner 0x95c28530c33c7297d6ba92177a3b82575ff0dfa3)"
evidence:
  level: executed
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks"
---

## Summary

Contract `0xdbd7fbe5b7cd56f99c059dc24052009d2626125c` (Etherscan tag: deployed by Pimlico: ERC-4337 Bundler 203). It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Rule: stored-key (by upgrade). Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0x847baa23f56eb3759f3fa623827dc3978eb42657 with UPGRADE_INTERFACE_VERSION(), owner 0x95c28530c33c7297d6ba92177a3b82575ff0dfa3.
- Reviewed through the root issue's mechanism: the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 179 transactions called it in the 90 days before that block; last on 2026-11-17.
- 113 signature recoveries in the study's two-week trace window.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
