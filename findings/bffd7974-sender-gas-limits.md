---
id: bffd7974-sender-gas-limits
title: "0xbffd7974: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xbffd79740f9dbb1db94f53bc4c7f8e6ae67b2678"
  family: "cdd0f5c7914f6e5db5080e030c7761f9"
  upgradeable: "no"
  rating: LOW
  value_usd: 19309
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 123
  last_active: 2026-11-17
  recoveries_14d: 34
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 19309, txs_90d 123, last_active 2026-11-17 (not rating-relevant)."
---

## Summary

unnamed contract: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xb3bc1bc8794448071824472e0c859d89c6c7910e5f650acea03f1c23a210da8a (block 26369849). The sender's limit was tight, not the…. Executed.
- Study replay in row note: tx 0xb3bc1bc8794448071824472e0c859d89c6c7910e5f650acea03f1c23a210da8a (block 26369849) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- no source in dossier; bytecode fetched at block 26438999 (cast code) only

## Impact and exposure

- Value held at block 26,438,999: $19,309 (ETH and 49 priced tokens).
- Activity: 123 transactions called it in the 90 days before that block; last on 2026-11-17.
- 34 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
