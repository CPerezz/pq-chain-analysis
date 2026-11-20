---
id: upgradedvg-61ffa596-signer-upgrade-only
title: "UpgradeDVG: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x61ffa596abbba47fe6014bda91f894b2dae6de05"
  family: "25d336a64ea964a113469087beb6ab7d"
  name: "UpgradeDVG"
  upgradeable: "yes"
  admin: "admin Safe 0x59e83877… (2 of 3)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "admin Safe 0x59e83877… (2 of 3)"
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
  note: "Safe admin can upgrade"
---

## Summary

UpgradeDVG: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: UpgradeDVG isValidSignature: the stored signer must sign the allowance. Read (function text).
- Update path, read at block 26,438,999: proxy to 0x89a46428e749e23c187584ba8e91ce62f0a2c1fb, admin 0x59e83877bd248cbfe392dbb5a8a29959bcb48592.
- transparent proxy, impl 0x89a46428…, admin slot 0x59e83877…
- eth_call upgradeTo(impl) from the admin succeeds; admin is a Safe, threshold 2, 3 owners
- txs_90d=0, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

the upgrade holder deploys an implementation whose signer check accepts the new key (or ERC-1271) and upgrades before the signer gains real code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
