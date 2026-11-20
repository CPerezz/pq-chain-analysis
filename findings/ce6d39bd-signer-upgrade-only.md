---
id: ce6d39bd-signer-upgrade-only
title: "0xce6d39bd: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xce6d39bd8304044578306ab531490ecd94384f13"
  family: "7ea2be921b4114e6cab0c2ef5f422623"
  upgradeable: "yes"
  admin: "owner() of proxy 0x2e6ec1bb… = 0x32f238d9… (nonce/code not read: node down)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "owner 0x32f238d9… of UUPS proxy 0x2e6ec1bb…"
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
  note: "Live proxy with an owner-gated UUPS upgrade: LOW. If the signature check compares with worker() (slot 0), the key is settable and the row is refuted instead."
---

## Summary

OZ v5 UUPS implementation (USDC fee/worker contract, 14,512 bytes). The 'copy of template 06599eb9 (DEXVaultV1)' match is wrong: different code. The queue lists a live proxy 0x2e6ec1bb… running this code with a nonzero owner.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Placed by a rule; copy of template 06599eb9, not read on its own.
- Update path, read at block 26,438,999: UPGRADE_INTERFACE_VERSION(), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- Decompile (heimdall): upgradeToAndCall checks __self == 0xce6d39bd and owner == msg.sender, so this address is a deployed implementation; owner() here = 0 (uninitialized impl)
- review/queue.csv row 0x2e6ec1bb…: 'proxy to 0xce6d39bd… with UPGRADE_INTERFACE_VERSION(), owner 0x32f238d9d047b049a46b04d5f59280e4ba736975'
- Decompile: owner-only 0x9e283464(address) writes slot 0 (worker()); owner-only setters also exist for usdcFee

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner of 0x2e6ec1bb upgrades to an implementation with a new signer, or sets it if the signer turns out to be worker().

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
