---
id: ddaa5e6c-signer-upgrade-only
title: "0xddaa5e6c (tagged deployed by CryptoHub Ownership Shares: Deployer): signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xddaa5e6c5657c5070234187679109730369c6f03"
  family: "3cec2aec39af2ac9a774bc0e3469116f"
  label: "deployed by CryptoHub Ownership Shares: Deployer"
  upgradeable: "yes"
  admin: "0xdd48fa33ab3e6a094b1ca89c1578b9ca96d0e563"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0xd6a457bb9ddbcb428b7553db1da3f9db6585872b with upgradeTo(address), owner 0xdd48fa33ab3e6a094b1ca89c1578b9ca96d0e563)"
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

Contract `0xddaa5e6c5657c5070234187679109730369c6f03` (Etherscan tag: deployed by CryptoHub Ownership Shares: Deployer). It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Placed by a rule; copy of template 302b95f0, not read on its own.
- Update path, read at block 26,438,999: proxy to 0xd6a457bb9ddbcb428b7553db1da3f9db6585872b with upgradeTo(address), owner 0xdd48fa33ab3e6a094b1ca89c1578b9ca96d0e563.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
