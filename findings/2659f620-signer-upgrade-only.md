---
id: 2659f620-signer-upgrade-only
title: "0x2659f620: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2659f6208b53c691c8969c5f06a776f37be65e5a"
  family: "ffb8be26ba8e6a27704ca3665a517c33"
  upgradeable: "yes"
  admin: "owner 0xDc4C1D5D… (EOA, nonce 181)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "owner 0xDc4C1D5D… (EOA, nonce 181)"
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
  note: "live EOA owner can upgrade"
---

## Summary

contract: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Placed by a rule; copy of template ee56db4b, not read on its own.
- Update path, read at block 26,438,999: proxy to 0x5bd4c5cca8e54da0d32119590d2bb327c6ab9718 with upgradeTo(address), owner 0xdc4c1d5d42f829dfd4b772d3a678cfb178ee6476.
- proxy, impl 0x5bd4c5cc…; eth_call upgradeTo(impl) from the owner succeeds
- owner has no code, nonce 181
- txs_90d=0, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

the upgrade holder deploys an implementation whose signer check accepts the new key (or ERC-1271) and upgrades before the signer gains real code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
