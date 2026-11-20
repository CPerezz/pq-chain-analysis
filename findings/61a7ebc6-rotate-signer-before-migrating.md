---
id: 61a7ebc6-rotate-signer-before-migrating
title: "0x61a7ebc6: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x61a7ebc69a34e72005a195b42b5d5577c20032ad"
  family: "83cce2504548dd9795515fe74547ea34"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  value_usd: 3418919
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 24910
  last_active: 2026-11-18
  recoveries_14d: 1383
fix:
  layer: onchain-config
  who_acts: "vault owner (Safe 3/5)"
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
  note: "LOW: live Safe owner and setter."
---

## Summary

Unverified UUPS vault. Withdrawal requests need two operator signers; a signer with code blocks new requests.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (setRateLimitConfig, setSigners). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction loses its effect with code at the signer.
- reading 83cce250: the owner replaces signers via 0xa3772662 and finalizers via 0xf1c40f8b
- owner() = 0x07e4909e, a Safe with threshold 3 of 5 owners

## Impact and exposure

- Value held at block 26,438,999: $3.4M (ETH and 49 priced tokens, over 2 addresses).
- Activity: 24,910 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,383 signature recoveries in the study's two-week trace window.

## Remediation

The owner Safe replaces the key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
