---
id: d28bf2cc-signer-upgrade-only
title: "0xd28bf2cc: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xd28bf2cc0a9ea58712dd7de60a0b5cad756ea5e8"
  family: "ba5b39c1fbce804e36e8fab1f77b59b7"
  copies: 4
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "whoever holds AccessControl-style role 0x10 on the account (checked via library 0x01448c53)"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "The key is settable by a role-gated reset, not only by code upgrade: refuted for 'no function replaces it'; same pattern as rotate-signer-before-migrating. Guardian/admin actions themselves (enforceOnlyGuardianRecoveryAddress etc.) are plain msg.sender checks, unaffected by EIP-8151 either way."
---

## Summary

Admin/member wallet (24,561 bytes) delegating guardian- and tx-recovery logic to two fixed libraries. The tx-recovery signer (the ecrecover-checked key) is settable: a role-0x10 holder can clear it and a fresh one can then be initiated, independent of the old key's own signature.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: delegates to a fixed address.
- Decompiled libraries 0xfb0f6c6143b76f1e0d40a314a7c49b9b6f9c1d8b and 0xd629b80b4b5073a1edc04316c4ca37af899566a9 (publicnode, latest, block ~26452845 — non-proxy contracts, code immutable since 26438999): d28bf2cc's own Unresolved_0955b60e delegates to library 0x01448c53.Unresolved_228a1a56(0x10) [role check] then branches to d629b80b.ab3daed3() 'TxRecoveryCleared' or fb0f6c61.dac24e41() 'GuardianRecoveryCleared'
- d629b80b.Unresolved_747c6388(bytes32,...): address var_a = ecrecover(arg0,...); return var_a == store_b — this is the only ecrecover use, checked against store_b (the tx-recovery address)
- d629b80b.Unresolved_0dca2a05/8b14a08b (set/initiate a new tx-recovery address) both require !store_b, i.e. they work once store_b has been cleared by the role-0x10 holder — a setter independent of the stored key's signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

A role-0x10 holder (the account's admin/owner role) clears the tx-recovery address and a new one is initiated.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
