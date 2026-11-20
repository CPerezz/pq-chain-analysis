---
id: archetype-750ee352-signer-upgrade-only
title: "ArchetypeLogic: signer replaceable only by an upgrade"
project: archetype
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x750ee3529d13819e00e4e67063d6e500870d5af3"
  family: "16b829f05172c402e45a80881f981b85"
  name: "ArchetypeLogic"
  upgradeable: "yes"
  admin: "0xcaf42ff1ca79bb4929f76cebd50ab0724c4ee0cd"
  rating: LOW
  value_usd: 3235
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 8
  last_active: 2026-10-29
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0x6aad73c8ca98b8e34f314f74875f88f9bdbee339, admin 0xcaf42ff1ca79bb4929f76cebd50ab0724c4ee0cd)"
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

`ArchetypeLogic` at `0x750ee3529d13819e00e4e67063d6e500870d5af3`. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Archetype affiliate check: the signer must be the affiliate signer of the collection's configuration. Read from source.
- Update path, read at block 26,438,999: proxy to 0x6aad73c8ca98b8e34f314f74875f88f9bdbee339, admin 0xcaf42ff1ca79bb4929f76cebd50ab0724c4ee0cd.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $3,235 (ETH and 49 priced tokens).
- Activity: 8 transactions called it in the 90 days before that block; last on 2026-10-29.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
