---
id: 72cb924a-entry-by-own-signature-only
title: "0x72cb924a: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0x72cb924a78b9335d547e6896bbcc6b94744927f6"
  family: "5d33839e6105e671abb99017c069180c"
  copies: 3
  upgradeable: "yes"
  rating: LOW
  txs_90d: 1871
  last_active: 2026-11-18
  recoveries_14d: 47
fix:
  layer: account-migration
  who_acts: "the order maker"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Escrow comes back through the direct cancelOrder call, so nothing is locked. value_usd None, txs_90d 1871."
---

## Summary

Unverified upgradeable limit-order contract: signed limit orders by the user; deposits sit in a LimitOrderVault. A maker with real code can't have orders filled.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: limit orders signed by the user named. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- heimdall decompile of impl 0x3b6a7e2c...: cancelOrder(...) checks the order isn't filled and calls limitOrderVault withdraw for msg.sender (direct refund, no signature)
- EIP-1967 impl slot = 0x3b6a7e2c...; admin slot = 0x5fa3422b...; owner() = 0x31781b4e... at 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 1,871 transactions called it in the 90 days before that block; last on 2026-11-18.
- 47 signature recoveries in the study's two-week trace window.

## Remediation

The maker cancels its order directly to recover escrowed funds, or keeps a 7702 delegation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
