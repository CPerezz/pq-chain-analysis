---
id: 6b750547-signer-upgrade-only
title: "0x6b750547: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6b75054748bd46fc33999d2062696209fc159456"
  family: "0fbffe3168bcde0e806679453f0abb19"
  upgradeable: "yes"
  admin: "upgrade admin 0x00c8b032…8ede (EOA, nonce 9), kept in slot 0x6c"
  rating: LOW
  value_usd: 17
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "upgrade admin 0x00c8b032…8ede (EOA, nonce 9), kept in slot 0x6c"
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
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "'called through its own checks' resolved to a live EOA admin"
---

## Summary

contract: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0xcb91d10796bb55eac5c048c4de6f660a94acc7a9 with upgradeTo(address), called through its own checks.
- impl 0xcb91d107… (heimdall): upgradeTo needs msg.sender == address(slot 0x6c >> 8); slot 0x6c at the block gives 0x00c8b032c76bc8e669ce43b2ba03705fd52a8ede
- eth_call upgradeTo(0xcb91d107…) from that address succeeds at block 26438999; it has no code and nonce 9
- txs_90d=0, value_usd=17

## Impact and exposure

- Value held at block 26,438,999: $17 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

the upgrade holder deploys an implementation whose signer check accepts the new key (or ERC-1271) and upgrades before the signer gains real code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
