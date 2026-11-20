---
id: d7259ac2-signer-upgrade-only
title: "0xd7259ac2: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd7259ac28bfbc26555a5cbafac117af20fe0233b"
  family: "817e7fe45f0bd4d5932741d1f048a8c2"
  upgradeable: "yes"
  admin: "0x8a18184f27e9a3a255b131a50ae8052890af9cfa"
  rating: LOW
  txs_90d: 3274
  last_active: 2026-11-18
  recoveries_14d: 1956
fix:
  layer: contract-upgrade
  who_acts: "EOA owner 0xb083baa196…"
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
  note: "Live owner EOA: LOW."
---

## Summary

One stored verifier behind a proxy; no setter seen, but transferOwnership exists and the implementation can be upgraded. 1,956 recoveries in the prior 14 days.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: one stored verifier behind a proxy; no setter name seen. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0x6a40efe72c9d51188604b4d83724fd3baf7d3589, admin 0x8a18184f27e9a3a255b131a50ae8052890af9cfa.
- EIP-1967 admin slot at 26438999 = 0x8a18184f… (6524 bytes, nonce 1); its owner() = 0xb083baa196…
- that owner has no code and nonce 5 at 26438999 (active EOA)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3,274 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,956 signature recoveries in the study's two-week trace window.

## Remediation

Admin owner upgrades the verifier.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
