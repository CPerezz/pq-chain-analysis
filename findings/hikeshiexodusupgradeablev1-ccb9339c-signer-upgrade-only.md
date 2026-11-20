---
id: hikeshiexodusupgradeablev1-ccb9339c-signer-upgrade-only
title: "HikeshiExodusUpgradeableV1: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xccb9339c825198a905dc078f40fc1f8e7a1720c7"
  family: "d05c6fed56426aab0dd5edbd0526dd8f"
  name: "HikeshiExodusUpgradeableV1"
  upgradeable: "yes"
  admin: "0xb0de947d1bc75ea84c739fef494976adc9a8e2f2"
  rating: LOW
  txs_90d: 250
  last_active: 2026-11-07
  recoveries_14d: 2
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0x0608fdd96736a648c9c77f3b98791b4c4281d0b7 with UPGRADE_INTERFACE_VERSION(), owner 0xb0de947d1bc75ea84c739fef494976adc9a8e2f2)"
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

`HikeshiExodusUpgradeableV1` at `0xccb9339c825198a905dc078f40fc1f8e7a1720c7`. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Hikeshi mint: signed by _CLAIM_ADMIN_SIGNER, fixed in the code. Read from source.
- Update path, read at block 26,438,999: proxy to 0x0608fdd96736a648c9c77f3b98791b4c4281d0b7 with UPGRADE_INTERFACE_VERSION(), owner 0xb0de947d1bc75ea84c739fef494976adc9a8e2f2.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 250 transactions called it in the 90 days before that block; last on 2026-11-07.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
