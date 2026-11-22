---
id: 0c0988e8-signer-upgrade-only
title: "0x0c0988e8: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0c0988e882ceffff0f8da4a645759265d2ca51a5"
  family: "358ff96ac68f301f269e1404f528bf6e"
  upgradeable: "yes"
  admin: "0x157875c30f83729ce9c1e7a1568ec00250237862"
  rating: LOW
  value_usd: 1995
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 642
  last_active: 2026-11-18
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0xcb7c223957da7ff75d65b502acf6be4a74c3193a with UPGRADE_INTERFACE_VERSION(), owner 0x157875c30f83729ce9c1e7a1568ec00250237862)"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks"
---

## Summary

Contract `0x0c0988e882ceffff0f8da4a645759265d2ca51a5`. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0xcb7c223957da7ff75d65b502acf6be4a74c3193a with UPGRADE_INTERFACE_VERSION(), owner 0x157875c30f83729ce9c1e7a1568ec00250237862.
- Reviewed through the root issue's mechanism: the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $1,995 (ETH and 49 priced tokens).
- Activity: 642 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
