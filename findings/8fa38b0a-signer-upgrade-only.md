---
id: 8fa38b0a-signer-upgrade-only
title: "0x8fa38b0a: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8fa38b0a1c6cc0ddaddf4da8fd54d3cea1266a77"
  family: "e071da316a765a6618dffd574b6df930"
  upgradeable: "yes"
  admin: "owner 0xA710CEe5… (EOA, nonce 138)"
  rating: LOW
  txs_90d: 175
  last_active: 2026-11-17
  recoveries_14d: 200
fix:
  layer: contract-upgrade
  who_acts: "owner 0xA710CEe5… (EOA, nonce 138)"
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
  note: "live EOA owner can upgrade"
---

## Summary

contract: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored keys behind an upgradeable implementation; no setter name seen. Bytecode and names. Executed: a real transaction loses its effect with code at the signer.
- Update path, read at block 26,438,999: proxy to 0x1fe638b2a72235c6a0538f7bffa42951ead9796a with UPGRADE_INTERFACE_VERSION(), owner 0xa710cee5c17874906783ecf8fa3656550e805612.
- UUPS proxy, impl 0x1fe638b2…; eth_call upgradeToAndCall(impl,'') from the owner succeeds at block 26438999
- owner 0xA710CEe5…: no code, nonce 138
- txs_90d=175, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 175 transactions called it in the 90 days before that block; last on 2026-11-17.
- 200 signature recoveries in the study's two-week trace window.

## Remediation

the upgrade holder deploys an implementation whose signer check accepts the new key (or ERC-1271) and upgrades before the signer gains real code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
