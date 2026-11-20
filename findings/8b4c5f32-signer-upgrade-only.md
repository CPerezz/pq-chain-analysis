---
id: 8b4c5f32-signer-upgrade-only
title: "0x8b4c5f32: signer replaceable only by an upgrade"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8b4c5f329dc428eb5ab40a367269d7c763f3819a"
  family: "18d240635452bac91791a3fac7340a7a"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody — no update path exists"
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
  rating: MEDIUM
  note: "No update path, but transfer() remains open so nothing is locked — MEDIUM, not HIGH."
---

## Summary

Same pattern as 0x81e54d1198d5ab7df155ae5f0997c3c30f1bfa88: the row address is itself a live UUPS-style proxy (admin slot zero) to implementation 0x882066717e47e757a4495ac72d90a0ae51c4c7b2 (23,431 bytes); no setter and no upgrade selector found anywhere in it. transfer(address,uint256) is a working exit.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0x882066717e47e757a4495ac72d90a0ae51c4c7b2: no admin, no upgrade function in the implementation.
- node, block 26438999: eip1967 implementation slot = 0x882066717e47e757a4495ac72d90a0ae51c4c7b2, admin slot = 0
- batch facts: implementation_bytes=23431, setters=[], upgrades=[], exits=["transfer(address,uint256)"]

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None available on-chain.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
