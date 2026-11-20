---
id: 423d607b-signer-upgrade-only
title: "0x423d607b: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x423d607bd4e213e9b64a54b324ab7f632feec647"
  family: "f09751f40677d19a6056e807e8340181"
  upgradeable: "yes"
  admin: "0x7bff45b11b0b652deb69256c2abf87771704dca3"
  rating: LOW
  value_usd: 1209
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 9056
  last_active: 2026-09-25
fix:
  layer: contract-upgrade
  who_acts: "EOA owner 0x7bff45b1…"
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
  note: "Live, highly active owner EOA: LOW."
---

## Summary

Stored-key contract (copy of template ee56db4b) behind a UUPS proxy; the signer has no setter but the implementation can be replaced.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Placed by a rule; copy of template ee56db4b, not read on its own.
- Update path, read at block 26,438,999: proxy to 0x4f06a7ed7a5d3de9da4c5c6e23506975cb36dc90 with UPGRADE_INTERFACE_VERSION(), owner 0x7bff45b11b0b652deb69256c2abf87771704dca3.
- owner() at 26438999 = 0x7bff45b11b0b652deb69256c2abf87771704dca3
- that owner has no code and nonce 67038 at 26438999 (very active EOA)

## Impact and exposure

- Value held at block 26,438,999: $1,209 (ETH and 49 priced tokens).
- Activity: 9,056 transactions called it in the 90 days before that block; last on 2026-09-25.

## Remediation

Owner calls upgradeToAndCall.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
