---
id: 61d89508-signer-upgrade-only
title: "0x61d89508: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x61d895084594df523ca7df5b4d14642c0b17dcff"
  family: "69fedfd0054f5eaf60711b61796c59da"
  copies: 13
  upgradeable: "yes"
  rating: LOW
  value_usd: 2
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 42
  last_active: 2026-11-11
  recoveries_14d: 4
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0x94f55258670a0a9b2722f7d9ddf3d0eca2d8bbcc with upgradeTo(address), called through its own checks)"
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

Contract `0x61d895084594df523ca7df5b4d14642c0b17dcff`, with 12 more addresses running its code. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Rule: stored-key (by upgrade). Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0x94f55258670a0a9b2722f7d9ddf3d0eca2d8bbcc with upgradeTo(address), called through its own checks.
- Reviewed through the root issue's mechanism: the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $2 (ETH and 49 priced tokens, over 13 addresses).
- Activity: 42 transactions called it in the 90 days before that block; last on 2026-11-11.
- 4 signature recoveries in the study's two-week trace window.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
