---
id: multisign-b60fa2ad-sender-gas-limits
title: "MultiSign: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xb60fa2ad48959c016fb7545d045aeb60086aca2a"
  family: "7d5e2ccb86db47cfc8cdc144cceb7e60"
  copies: 34
  name: "MultiSign"
  label: "deployed by Ripple: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 8104279
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 839
  last_active: 2026-11-17
  recoveries_14d: 272
fix:
  layer: offchain
  who_acts: "transaction sender / wallet (raise gas limit)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-sender-gas-limits"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 8104279, txs_90d 839, last_active 2026-11-17 (not rating-relevant)."
---

## Summary

MultiSign: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xc9f97a09e9a872bb9a24693de7bff8002e8959375efbd1927cb8f439ee53a6a8 (block 26407735). The sender's limit was tight, not the…. Executed.
- Study replay in row note: tx 0xc9f97a09e9a872bb9a24693de7bff8002e8959375efbd1927cb8f439ee53a6a8 (block 26407735) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (2 files): no ecrecover call with literal gas

## Impact and exposure

- Value held at block 26,438,999: $8.1M (ETH and 49 priced tokens, over 34 addresses).
- Activity: 839 transactions called it in the 90 days before that block; last on 2026-11-17.
- 272 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
