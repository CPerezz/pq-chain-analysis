---
id: multisigbridge-843ecfdb-signer-upgrade-only
title: "MultiSigBridge: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x843ecfdb484faee8fd9f355ea4cbd0ff242f8f81"
  family: "18b5a5c2b8c83f929e79cdfb4b917a8c"
  name: "MultiSigBridge"
  label: "Bridge Oracle: TokenBridge MultiSig"
  upgradeable: "yes"
  admin: "0x60026525f06e886d30f18d5da25f3d1ef82993ef"
  rating: LOW
  value_usd: 29
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (upgrade(), owner 0x60026525f06e886d30f18d5da25f3d1ef82993ef)"
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

`MultiSigBridge` at `0x843ecfdb484faee8fd9f355ea4cbd0ff242f8f81` (Etherscan tag: Bridge Oracle: TokenBridge MultiSig). It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: MultiSigBridge getManagerFromSignatures: signatures of distinct stored managers. Read (function text).
- Update path, read at block 26,438,999: upgrade(), owner 0x60026525f06e886d30f18d5da25f3d1ef82993ef.
- Reviewed through the root issue's mechanism: the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $29 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
