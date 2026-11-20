---
id: 944ec709-signer-upgrade-only
title: "0x944ec709: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x944ec709a144a5abf3ac237dadf02b40f92007ee"
  family: "9ff1bbe8f3d9b40efd7c2bac0f30fb54"
  copies: 6
  upgradeable: "yes"
  admin: "0xc2f33f9eb213f986f11b214fcaadd6f32e23938f"
  rating: LOW
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "upgrade admin = owner() 0xeEB62F01… (read at block; the row says 0xc2f33f9e…, also nonce 0)"
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
  note: "Anon's rule (2026-11-20): a key that has never sent a transaction is presumed live; inactivity does not show the key is lost. So the party that can rotate the signer or upgrade the code can act: LOW. Earlier doubt: the upgrade path is authorized, but its only holder has never transacted"
---

## Summary

contract: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Placed by a rule; copy of template 8e7d5287, not read on its own.
- Update path, read at block 26,438,999: proxy to 0xf6ffd57c3049c3e59640e30a96ef94f9dbdba0aa with UPGRADE_INTERFACE_VERSION(), owner 0xc2f33f9eb213f986f11b214fcaadd6f32e23938f.
- proxy (EIP-1967 impl 0xf6ffd57c…, UUPS); eth_call upgradeToAndCall(current impl,'') from 0xeEB62F01… succeeds at block 26438999
- owner 0xeEB62F01… has no code, nonce 0, 0.01 ETH: a key that has never sent a transaction, so it can't be shown to be live; the row's owner 0xc2f33f9e… is also nonce 0
- txs_90d=0, value_usd=1

## Impact and exposure

- Value held at block 26,438,999: $1 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

resolve who holds the upgrade path, then upgrade before the signer gains real code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
