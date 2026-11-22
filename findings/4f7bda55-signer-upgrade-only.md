---
id: 4f7bda55-signer-upgrade-only
title: "0x4f7bda55: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4f7bda55fe429c2de625b843e77d9bb8d450fad7"
  family: "19e366500e90e3fa3d87e70543cb5393"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 4
  last_active: 2026-11-07
  recoveries_14d: 1
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0x5f343440c9435d329167785d8ef065bd782887e1 with upgradeAdmin(), called through its own checks)"
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

Contract `0x4f7bda55fe429c2de625b843e77d9bb8d450fad7`. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Rule: stored-key (by upgrade). Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0x5f343440c9435d329167785d8ef065bd782887e1 with upgradeAdmin(), called through its own checks.
- Reviewed through the root issue's mechanism: the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-11-07.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
