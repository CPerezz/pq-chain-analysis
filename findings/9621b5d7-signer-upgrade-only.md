---
id: 9621b5d7-signer-upgrade-only
title: "0x9621b5d7: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9621b5d7aa295f7cc686f1c07a547c916ce200f3"
  family: "6dc5b6826e4454bbd1c886c1bd90e2dc"
  copies: 149
  upgradeable: "yes"
  rating: LOW
  value_usd: 960
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 342
  last_active: 2026-11-18
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0x9fd12e8972f23b7842cf2e137746f1f8103ba2e7 with UPGRADE_TYPEHASH(), called through its own checks)"
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

Contract `0x9621b5d7aa295f7cc686f1c07a547c916ce200f3`, with 148 more addresses running its code. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: 151 proxies whose upgrade is signed by a signer that is a constant in the code. Bytecode and names.
- Update path, read at block 26,438,999: proxy to 0x9fd12e8972f23b7842cf2e137746f1f8103ba2e7 with UPGRADE_TYPEHASH(), called through its own checks.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $960 (ETH and 49 priced tokens, over 149 addresses).
- Activity: 342 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
