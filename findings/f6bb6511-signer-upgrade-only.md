---
id: f6bb6511-signer-upgrade-only
title: "0xf6bb6511 (tagged deployed by Biconomy: ERC-4337 Bundler 6): signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf6bb6511368f1765fd3b983b58b5aa18f39d8bf3"
  family: "9a621c98aea223c6326cff26b69b1559"
  label: "deployed by Biconomy: ERC-4337 Bundler 6"
  upgradeable: "yes"
  admin: "each account itself, via its owner-signed user operation"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "each account's owner (by a signed user operation)"
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
  verdict: confirmed
  rating: LOW
  note: "Owner-signed self-upgrade is the same convention as the SimpleAccount rows: LOW. No direct-call path: every action needs the owner's ECDSA key, so the upgrade must happen before the key takes code."
---

## Summary

A 4337 account implementation (EntryPoint v0.6; group/split-pay/auto-saving features): validateUserOp compares ecrecover to the owner kept in storage; execute and upgradeTo are reachable only via the EntryPoint or the account itself. The owner can upgrade the account with a signed user operation before the key takes code.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Rule: stored-key (by upgrade). Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- heimdall decompile: execute (b61d27f6) requires msg.sender == EntryPoint 0x5ff137d4; upgradeTo/upgradeToAndCall require msg.sender == address(this); initialize(address) stores the owner in slot 1 (offset 2 bytes); no owner setter
- dossier proxy 0x418349e3: owner = 0x3bd5a160…82be (EOA, no code, nonce 0, as normal for a 4337 owner); 0.189 ETH held
- Upgraded(row) logs: proxies 0xb808ff0e, 0x7c47ef07, 0xdd559bd2, 0x55aa9eb9 also took this implementation (blocks 20.00M-20.24M)
- the row itself has slot 1 = 0xff (initializers disabled)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner signs a user operation that calls upgradeTo with an implementation accepting a new key, before migrating.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
