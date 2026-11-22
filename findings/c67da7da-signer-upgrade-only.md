---
id: c67da7da-signer-upgrade-only
title: "0xc67da7da (tagged deployed by Pimlico: ERC-4337 Bundler 211): signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc67da7daac1adf5099fef0a02a0aff7561b70fa0"
  family: "fe6f44b3a791d41103d4a9960f98c8fe"
  copies: 2
  label: "deployed by Pimlico: ERC-4337 Bundler 211"
  upgradeable: "yes"
  admin: "0x4ba5ce7396399f96b91d2545b04cef961235a6f4"
  rating: LOW
  txs_90d: 1
  last_active: 2026-11-14
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0xb6c0db1bd1b8d63b5aacf7d50eddee68311374c0 with UPGRADE_INTERFACE_VERSION(), owner 0x4ba5ce7396399f96b91d2545b04cef961235a6f4)"
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

Contract `0xc67da7daac1adf5099fef0a02a0aff7561b70fa0` (Etherscan tag: deployed by Pimlico: ERC-4337 Bundler 211), with 1 more addresses running its code. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Rule: stored-key (by upgrade). Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0xb6c0db1bd1b8d63b5aacf7d50eddee68311374c0 with UPGRADE_INTERFACE_VERSION(), owner 0x4ba5ce7396399f96b91d2545b04cef961235a6f4.
- Reviewed through the root issue's mechanism: the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
