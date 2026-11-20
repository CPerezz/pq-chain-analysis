---
id: 4cecb7f9-signer-upgrade-only
title: "0x4cecb7f9: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4cecb7f987d220fe2e8608149fa76ed6d021ad11"
  family: "498b59b6a1d4e7dfa2f41a0d4560014f"
  upgradeable: "yes"
  admin: "0xa285717bfd608468566bfbda742b56b1177494f7"
  rating: LOW
  value_usd: 244
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 173
  last_active: 2026-11-12
  recoveries_14d: 30
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0x5eb65c20ed22ed7f754b603e798f00dc06425f65 with UPGRADE_INTERFACE_VERSION(), owner 0xa285717bfd608468566bfbda742b56b1177494f7)"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025)"
---

## Summary

Contract `0x4cecb7f987d220fe2e8608149fa76ed6d021ad11`. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0x5eb65c20ed22ed7f754b603e798f00dc06425f65 with UPGRADE_INTERFACE_VERSION(), owner 0xa285717bfd608468566bfbda742b56b1177494f7.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $244 (ETH and 49 priced tokens).
- Activity: 173 transactions called it in the 90 days before that block; last on 2026-11-12.
- 30 signature recoveries in the study's two-week trace window.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
