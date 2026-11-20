---
id: 7a956fd3-rotate-signer-before-migrating
title: "0x7a956fd3: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7a956fd329d0c616f2d1dde98bb35694f397df46"
  family: "96366355f343f4317845d8594a5137c7"
  upgradeable: "no"
  rating: LOW
  value_usd: 1083
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 48018
  last_active: 2026-11-18
  recoveries_14d: 8395
fix:
  layer: onchain-config
  who_acts: "owner"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Setter callable by a live EOA owner; only sponsorship pauses."
---

## Summary

Unverified ERC-4337 VerifyingPaymaster; sponsorship needs an ECDSA signature by the stored verifying signer. Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (changeVerifyingSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- reading.first.json: selector 0xa0ad70d3 (changeVerifyingSigner) is owner-only (slot 0), no signature needed
- owner() = 0xF6e22ABb…; owner is an EOA (no code, nonce 34) at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $1,083 (ETH and 49 priced tokens).
- Activity: 48,018 transactions called it in the 90 days before that block; last on 2026-11-18.
- 8,395 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls changeVerifyingSigner with a fresh EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
