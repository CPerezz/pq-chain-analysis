---
id: b37d21b7-signer-upgrade-only
title: "0xb37d21b7: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xb37d21b71f5a36cbe053ec0d467742f5be279c41"
  family: "23237bec3375339ba0abbf3d3d2462c9"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "No fixed key: delegateBySig only shortcuts the signer's own delegate() call, which stays open."
---

## Summary

Vesting/votes implementation behind ERC-1967 proxy 0x0229c005. Its only ecrecover is ERC-5805 delegateBySig, the holder's own signature, and delegate(address) stays open directly; there is no stored signer key.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: UPGRADE_INTERFACE_VERSION(), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- scanner: 1 ecrecover site, flows eq_storage/map_key/hashed/logged (nonce check + DelegateChanged)
- heimdall: delegate(address) writes storage_map_c[msg.sender] and emits DelegateChanged - same act by direct call
- proxy 0x0229c00583f64aebdc4533272e885ac065730917 impl = 0xb37d21b7; upgradeToAndCall requires msg.sender == slot 3 = 0x87a50065 (contract, 6594 bytes) @26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed: holders call delegate() directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
