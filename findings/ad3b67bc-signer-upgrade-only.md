---
id: ad3b67bc-signer-upgrade-only
title: "0xad3b67bc (tagged 1inch: Fusion Resolver (1inch Labs)): signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xad3b67bca8935cb510c8d18bd45f0b94f54a968f"
  family: "f971fb88e616896548268cd940e5b74a"
  label: "1inch: Fusion Resolver (1inch Labs)"
  upgradeable: "yes"
  admin: "ProxyAdmin 0xa8ecb78e0655823478a671a4bb4d8af08ec3ebe9 owned by Safe 0x9f8102b1bb05785bad2874f2c7b1aaea4c6d976a (3/4)"
  rating: LOW
  value_usd: 660
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 52756
  last_active: 2026-11-18
  recoveries_14d: 6
fix:
  layer: contract-upgrade
  who_acts: "3-of-4 Safe 0x9f8102b1… via ProxyAdmin 0xa8ecb78e…"
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
  note: "Live multisig admin: LOW."
---

## Summary

1inch Fusion Resolver ERC-1271 contract behind a proxy; a signer fixed in the code.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: ERC-1271 contract behind a proxy; a signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0x9acb6acfdebb4484da0f18eb14376d4f29c0dcdb, admin 0xa8ecb78e0655823478a671a4bb4d8af08ec3ebe9.
- EIP-1967 admin slot at 26438999 = 0xa8ecb78e…; owner() = Safe 0x9f8102b1… (same Safe as 0x33b41fe…)
- Safe getThreshold=3, 4 owners; two nonzero nonces (48,51), two nonce 0 — the Safe still signs with all 4 keys regardless of each owner's own tx history

## Impact and exposure

- Value held at block 26,438,999: $660 (ETH and 49 priced tokens).
- Activity: 52,756 transactions called it in the 90 days before that block; last on 2026-11-18.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

Upgrade to an implementation with a new signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
