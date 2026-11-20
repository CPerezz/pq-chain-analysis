---
id: 2756c25a-signer-upgrade-only
title: "0x2756c25a: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2756c25a0b42a7a6603c4d5ca9e227f9cae4aa48"
  family: "a3d6f21b7a1dc664d103636e36e0094c"
  upgradeable: "yes"
  admin: "owner 0x59b08ADE… (EOA with an EIP-7702 delegation, nonce 41)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "owner 0x59b08ADE… (EOA with an EIP-7702 delegation, nonce 41)"
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

- How it was placed: stored-key (by upgrade): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Placed by a rule; copy of template 35075ad3, not read on its own.
- Update path, read at block 26,438,999: proxy to 0xc00c85e3a500fd229a249b44a90bcc53de5a7544 with UPGRADE_INTERFACE_VERSION(), owner 0x59b08ade2203871edf20572d4e807691a42b9d11.
- UUPS proxy, impl 0xc00c85e3…; eth_call upgradeToAndCall from the owner succeeds at block 26438999
- owner 0x59b08ADE…: 0xef0100 delegation code, nonce 41, so it can still send transactions
- txs_90d=0, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

the upgrade holder deploys an implementation whose signer check accepts the new key (or ERC-1271) and upgrades before the signer gains real code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
