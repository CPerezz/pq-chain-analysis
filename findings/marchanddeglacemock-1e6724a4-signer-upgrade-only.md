---
id: marchanddeglacemock-1e6724a4-signer-upgrade-only
title: "MarchandDeGlaceMock: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1e6724a47b62ed89e1e74b119b127f593b53f3b8"
  family: "d04e61e65aa9015955a9ab2dda48822a"
  name: "MarchandDeGlaceMock"
  upgradeable: "yes"
  admin: "0xf953c3d475dc0a9877329f71e2ce3d2519a519a2"
  rating: LOW
  value_usd: 729
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0xe5585c269b67dc918487fc6da9bb7598d4249edc, admin 0xf953c3d475dc0a9877329f71e2ce3d2519a519a2)"
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

`MarchandDeGlaceMock` at `0x1e6724a47b62ed89e1e74b119b127f593b53f3b8`. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: MarchandDeGlace: whale and dolphin passes signed by SIGNER, an immutable; the proxy can replace the code. Read.
- Update path, read at block 26,438,999: proxy to 0xe5585c269b67dc918487fc6da9bb7598d4249edc, admin 0xf953c3d475dc0a9877329f71e2ce3d2519a519a2.
- Reviewed through the root issue's mechanism: the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $729 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
