---
id: 10fc9e6e-signer-upgrade-only
title: "0x10fc9e6e: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x10fc9e6ed49e648bde6b6214f07d8e63e12349e8"
  family: "214cc1d86462ac16b0a38c9d6e7dfc89"
  upgradeable: "yes"
  admin: "0xf65071a0bd70c15643e49e8e865710ea85f52379"
  rating: LOW
  txs_90d: 249
  last_active: 2026-11-14
  recoveries_14d: 15
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0xdcfd18e6e32e9e85c9fdf2cd3587b212061aa90a, admin 0xf65071a0bd70c15643e49e8e865710ea85f52379)"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025)"
---

## Summary

Contract `0x10fc9e6ed49e648bde6b6214f07d8e63e12349e8`. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade). Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0xdcfd18e6e32e9e85c9fdf2cd3587b212061aa90a, admin 0xf65071a0bd70c15643e49e8e865710ea85f52379.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 249 transactions called it in the 90 days before that block; last on 2026-11-14.
- 15 signature recoveries in the study's two-week trace window.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
