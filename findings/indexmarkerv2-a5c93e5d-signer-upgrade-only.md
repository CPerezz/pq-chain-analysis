---
id: indexmarkerv2-a5c93e5d-signer-upgrade-only
title: "IndexMarkerV2: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa5c93e5d9eb8fb1b40228bb93fd40990913db523"
  family: "26c1c1a9f8e19d90409228d552c735ff"
  name: "IndexMarkerV2"
  upgradeable: "yes"
  admin: "0x1cc0271fe94c490b26d0f6369b1c947ecad9b946"
  rating: LOW
  txs_90d: 1
  last_active: 2026-10-08
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0x74c0c77ec5dff8df9169ec95b03b187b868c655d with upgradeTo(address), owner 0x1cc0271fe94c490b26d0f6369b1c947ecad9b946)"
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

`IndexMarkerV2` at `0xa5c93e5d9eb8fb1b40228bb93fd40990913db523`. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0x74c0c77ec5dff8df9169ec95b03b187b868c655d with upgradeTo(address), owner 0x1cc0271fe94c490b26d0f6369b1c947ecad9b946.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-08.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
