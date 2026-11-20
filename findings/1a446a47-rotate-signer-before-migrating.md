---
id: 1a446a47-rotate-signer-before-migrating
title: "0x1a446a47: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x1a446a47aed68ef4f9b1536c5f8f27f9dc03f508"
  family: "2babc14ba9ef4ff6f96f6ef92b7a13c1"
  copies: 3696
  upgradeable: "yes"
  rating: NONE
  value_usd: 117479021
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 7018
  last_active: 2026-11-18
  recoveries_14d: 1795
fix:
  layer: none
  who_acts: "account owner"
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
  verdict: refuted
  rating: NONE
  note: "ERC-1271 for the same signer, so refuted; the setter fallback would give LOW anyway. Bytecode only."
---

## Summary

Unverified Circle single-owner 4337 account (3,695 proxies). The owner is checked by recovery with a fall-through to ERC-1271 on the owner.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one address in storage and the only such address the code names is its owner, which can be handed over (renounceNativeOwnership, transferNativeOwnership). Rule: stored-key (the owner). Executed: a real transaction reverts with code at the signer.
- reading 2babc14b: when ECDSA fails the code falls through to ERC-1271 on the owner
- rotation: transferNativeOwnership 0xf95d04b0, by the owner directly or the account itself

## Impact and exposure

- Value held at block 26,438,999: $117.5M (ETH and 49 priced tokens, over 3,696 addresses).
- Activity: 7,018 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,795 signature recoveries in the study's two-week trace window.

## Remediation

The owner implements ERC-1271 or rotates first.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
