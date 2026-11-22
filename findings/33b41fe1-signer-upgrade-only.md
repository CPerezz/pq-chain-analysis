---
id: 33b41fe1-signer-upgrade-only
title: "0x33b41fe1: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x33b41fe18d3a39046ad672f8a0c8c415454f629c"
  family: "77c8091b246880df8258db058535f6d4"
  copies: 2
  upgradeable: "yes"
  admin: "ProxyAdmin 0x3305184a01049d7c1e850c6be565bc447212e976 owned by Safe 0x9f8102b1bb05785bad2874f2c7b1aaea4c6d976a (3/4)"
  rating: LOW
  value_usd: 862195
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 45276
  last_active: 2026-11-18
  recoveries_14d: 24
fix:
  layer: contract-upgrade
  who_acts: "3-of-4 Safe 0x9f8102b1… via ProxyAdmin 0x3305184a…"
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

ERC-1271 contract behind a proxy answering for a signer fixed in its code; 45,276 txs in 90d.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: ERC-1271 contract behind a proxy answering for a signer fixed in its code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0xe9be12fd7e00bda01299f46afb2e63c33a707d87, admin 0x3305184a01049d7c1e850c6be565bc447212e976.
- EIP-1967 admin slot at 26438999 = 0x3305184a…; owner() = Safe 0x9f8102b1…
- Safe getThreshold=3, 4 owners; two with nonzero nonces (48,51), two with nonce 0 — nonce 0 does not disqualify a Safe signer, it only means that EOA has not itself sent a transaction

## Impact and exposure

- Value held at block 26,438,999: $862,195 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 45,276 transactions called it in the 90 days before that block; last on 2026-11-18.
- 24 signature recoveries in the study's two-week trace window.

## Remediation

Upgrade to an implementation with a new signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
