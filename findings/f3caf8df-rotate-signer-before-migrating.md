---
id: f3caf8df-rotate-signer-before-migrating
title: "0xf3caf8df: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xf3caf8dfa2c017961b8dcfd1c20cac5ebc091d2d"
  family: "63bc6d876989aed65d383deca14147ea"
  copies: 2
  upgradeable: "no"
  rating: NONE
  value_usd: 3998905
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 47
  last_active: 2026-11-16
  recoveries_14d: 23
fix:
  layer: none
  who_acts: "paymaster owner"
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
  note: "ERC-1271 for the same signer: refuted. If counted, LOW, but the owner EOA has never sent a transaction (nonce 0) and only signs off-chain."
---

## Summary

Unverified ERC-4337 paymaster with owner-signed vouchers. Recovery is compared with the owner, then falls through to ERC-1271 on the owner.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: paymaster: withdrawals and sponsorships are signed by its owner, which can be handed over. Bytecode and names. Executed: a real transaction loses its effect with code at the signer.
- reading 63bc6d87: empty or mismatched recovery -> ERC-1271 on the owner
- owner() = 0xAA736Ca1 (EOA, nonce 0); rotation via transferOwnership 0xf2fde38b

## Impact and exposure

- Value held at block 26,438,999: $4.0M (ETH and 49 priced tokens, over 2 addresses).
- Activity: 47 transactions called it in the 90 days before that block; last on 2026-11-16.
- 23 signature recoveries in the study's two-week trace window.

## Remediation

The owner implements ERC-1271 or hands over ownership.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
