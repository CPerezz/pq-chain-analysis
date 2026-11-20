---
id: 7246999f-signer-upgrade-only
title: "0x7246999f (tagged deployed by 1inch: Deployer 5): signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7246999fd1bab15b4ac7d1a23c3abeed63c51b86"
  family: "3aedfe0334c304d3038d1d56d343131a"
  label: "deployed by 1inch: Deployer 5"
  upgradeable: "yes"
  admin: "0x641208b5ce7642931cb6f48f9590d5ae7dee22bd"
  rating: LOW
  value_usd: 576
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 58
  last_active: 2026-11-17
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0x02f56bf179e0af6fdb5de68b6692cd195930d265, admin 0x641208b5ce7642931cb6f48f9590d5ae7dee22bd)"
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

Contract `0x7246999fd1bab15b4ac7d1a23c3abeed63c51b86` (Etherscan tag: deployed by 1inch: Deployer 5). It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: 1inch LeftoverExchanger ERC-1271: the signer must be _OWNER, fixed in the code. Same code idiom as template 10aaa29e, not read on its own.
- Update path, read at block 26,438,999: proxy to 0x02f56bf179e0af6fdb5de68b6692cd195930d265, admin 0x641208b5ce7642931cb6f48f9590d5ae7dee22bd.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $576 (ETH and 49 priced tokens).
- Activity: 58 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
