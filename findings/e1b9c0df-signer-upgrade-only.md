---
id: e1b9c0df-signer-upgrade-only
title: "0xe1b9c0df (tagged deployed by Pimlico: ERC-4337 Bundler 3): signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe1b9c0df920ef51b31d54ff91c95dc576c78b234"
  family: "4d522c0e81116f67ecdcba72bf0171b9"
  copies: 11
  label: "deployed by Pimlico: ERC-4337 Bundler 3"
  upgradeable: "yes"
  admin: "0xe127f897e154b9916c2a3b98e0d0b356e2e50574"
  rating: LOW
  value_usd: 21
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0xfb375e254b525633c485f7e8e89c0cb7175de22c with upgradeTo(address), owner 0xe127f897e154b9916c2a3b98e0d0b356e2e50574)"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks"
---

## Summary

Contract `0xe1b9c0df920ef51b31d54ff91c95dc576c78b234` (Etherscan tag: deployed by Pimlico: ERC-4337 Bundler 3), with 10 more addresses running its code. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Placed by a rule; copy of template ee56db4b, not read on its own.
- Update path, read at block 26,438,999: proxy to 0xfb375e254b525633c485f7e8e89c0cb7175de22c with upgradeTo(address), owner 0xe127f897e154b9916c2a3b98e0d0b356e2e50574.
- Reviewed through the root issue's mechanism: the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $21 (ETH and 49 priced tokens, over 11 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
