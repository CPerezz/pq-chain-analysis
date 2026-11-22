---
id: bf4cfccd-signer-upgrade-only
title: "0xbf4cfccd: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbf4cfccd11257e568a936a7867d138f54a43cffa"
  family: "cd637a1eb0ac78bc8fd1efd6773d4cbf, dfe2cd89bb4eb5db0ff4881d9415b0ab"
  copies: 2
  upgradeable: "yes"
  admin: "0x643381adf2f9a677539daef42a92cba2b12e17c6"
  rating: LOW
  value_usd: 13354
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2150
  last_active: 2026-11-18
  recoveries_14d: 258
fix:
  layer: contract-upgrade
  who_acts: "the owner upgrades the implementation"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "simple upgrade path"
---

## Summary

Contract `0xbf4cfccd11257e568a936a7867d138f54a43cffa`, with 1 more address running its code. Validators and guardians sign withdrawals; their keys are replaced only by an upgrade, which the owner can do.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: validators and guardians with thresholds behind an upgradeable proxy; no setter name seen. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Proxy to 0x81bb05904e3102b4312f855ccee48904deaa0a7c; the implementation has upgradeToAndCall and finalizeUpgrade; owner() is 0x643381adf2f9a677539daef42a92cba2b12e17c6.
- Executed: a real withdrawal reverts once its signer has code.
- 2,150 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $13,354 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,150 transactions called it in the 90 days before that block; last on 2026-11-18.
- 258 signature recoveries in the study's two-week trace window.

## Remediation

The owner upgrades the verification before signers take code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
