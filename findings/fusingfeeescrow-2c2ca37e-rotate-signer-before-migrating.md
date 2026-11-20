---
id: fusingfeeescrow-2c2ca37e-rotate-signer-before-migrating
title: "FusingFeeEscrow: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2c2ca37e1aaca05011942eca70a19549c9a119a9"
  family: "e7b78373259cace22099d4f65d86173e"
  copies: 4
  name: "FusingFeeEscrow"
  upgradeable: "no"
  rating: LOW
  value_usd: 340
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1294
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "hard-coded admin"
evidence:
  level: bytecode
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
  note: "Setter callable by a live EOA."
---

## Summary

FusingFeeEscrow (unverified); credits rely on an attester signature from a stored key. Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setAttester). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- heimdall decompile: setAttester requires msg.sender == 0x0ebefe57… (hard-coded)
- 0x0ebefe57… is an EOA (no code, nonce 406) at block 26438999; it is also owner()

## Impact and exposure

- Value held at block 26,438,999: $340 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 1,294 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

That address calls setAttester with a fresh EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
