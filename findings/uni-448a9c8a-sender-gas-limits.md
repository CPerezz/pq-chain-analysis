---
id: uni-448a9c8a-sender-gas-limits
title: "Uni: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x448a9c8a25dc1ec8af43c351bdd0919acbc5be7e"
  family: "d927799d742eda92c4d62ff1373d5ce2"
  copies: 7
  name: "Uni"
  label: "Uniswap Protocol: UNI Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 448975
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1042809
  last_active: 2026-11-18
  recoveries_14d: 76
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 448975, txs_90d 1042809, last_active 2026-11-18 (not rating-relevant)."
---

## Summary

Uni: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x04d967fb5be8449f715f75e2ca71f0b154a4f855ce746c4f8862975d5e3a2526 (block 26426725); other transactions of the family pass…. Executed.
- Study replay in row note: tx 0x04d967fb5be8449f715f75e2ca71f0b154a4f855ce746c4f8862975d5e3a2526 (block 26426725) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (1 files): no ecrecover call with literal gas

## Impact and exposure

- Value held at block 26,438,999: $448,975 (ETH and 49 priced tokens, over 7 addresses).
- Activity: 1,042,809 transactions called it in the 90 days before that block; last on 2026-11-18.
- 76 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
