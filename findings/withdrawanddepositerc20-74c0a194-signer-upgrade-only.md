---
id: withdrawanddepositerc20-74c0a194-signer-upgrade-only
title: "WithdrawAndDepositErc20: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x74c0a1946d10faf9048e9ac59d1401bbbfc54ca4"
  family: "27a55a390ffff6544add97ae721703c3"
  copies: 2
  name: "WithdrawAndDepositErc20"
  upgradeable: "yes"
  rating: LOW
  value_usd: 10655
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 46
  last_active: 2026-10-17
fix:
  layer: contract-upgrade
  who_acts: "whoever can satisfy the Partisia large-oracle verifier 0x343535…"
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
  note: "Same basis and same caveat as 0xf393d008…: LOW, large-oracle signer's own code status unconfirmed."
---

## Summary

WithdrawAndDepositErc20: same Partisia bridge pattern as 0xf393d008…, sharing the same largeOracle 0x3435359d…. Oracle-signed withdrawals with a separate, ecrecover-gated large-oracle update/upgrade path.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: each signature must come from the oracle at its position in the stored list; a bitmask counts them. Read from source.
- Update path, read at block 26,438,999: proxy to 0xaa350d6f83e90275bffd528cb18310880ae170d9 with upgradeTo(bytes,address), called through its own checks.
- largeOracle() = 0x3435359d…, same address and implementation as the sibling row
- all 3 current small oracles for this vault (0xe3be9de4…, 0xc5977bc2…, 0x39962c2e…) hold no code at 26438999

## Impact and exposure

- Value held at block 26,438,999: $10,655 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 46 transactions called it in the 90 days before that block; last on 2026-10-17.

## Remediation

Rotate the small-oracle set or upgrade through the large-oracle verifier.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
