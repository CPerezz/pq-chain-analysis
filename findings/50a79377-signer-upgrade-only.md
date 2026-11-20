---
id: 50a79377-signer-upgrade-only
title: "0x50a79377 (tagged deployed by Pimlico: ERC-4337 Bundler 212): signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x50a793775c5e6c89fb0ae385d9e19e5a6c38f418"
  family: "a19eb84bba0bc78edf9a39906a080543"
  label: "deployed by Pimlico: ERC-4337 Bundler 212"
  upgradeable: "no"
  rating: NONE
  txs_90d: 1
  last_active: 2026-11-14
fix:
  layer: none
  who_acts: "none"
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
  verdict: refuted
  rating: NONE
  note: "uninitialized implementation, so refuted by the rule; I did not read the template match because it does not change the verdict"
---

## Summary

An uninitialized UUPS implementation. Its initializers are disabled and its signer storage is empty, so no signature path works at this address. The proxies that use this code are separate addresses.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Rule: stored-key (by upgrade). Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: UPGRADE_INTERFACE_VERSION(), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- proxiableUUID() returns the EIP-1967 slot, so the address is a UUPS implementation (node, block 26438999)
- Initializers disabled: the OZ v5 init slot is type(uint64).max, or slot 0 is 0xff under the v4 layout; owner() is 0 (node, block 26438999)
- Storage slots 1-10/50/51/101/151/201/251/301 are empty and the balance is 0 (node, block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

none at this address; rate the proxies that point to it on their own

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
