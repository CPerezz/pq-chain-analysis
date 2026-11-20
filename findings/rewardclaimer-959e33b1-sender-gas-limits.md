---
id: rewardclaimer-959e33b1-sender-gas-limits
title: "RewardClaimer: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x959e33b167e66b09cb524e610e7ef7fb0e4e2d81"
  family: "0901b4858d38218ab66953420a396494"
  name: "RewardClaimer"
  upgradeable: "no"
  rating: LOW
  value_usd: 24001
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 980
  last_active: 2026-11-17
  recoveries_14d: 42
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 24001, txs_90d 980, last_active 2026-11-17 (not rating-relevant)."
---

## Summary

RewardClaimer: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xa3a23c70fcca95aa7a5872c75d639f505bd2dbdf04b8604cbf8ed711ec4050a8 (block 26353589); other transactions of the family pass…. Executed.
- Study replay in row note: tx 0xa3a23c70fcca95aa7a5872c75d639f505bd2dbdf04b8604cbf8ed711ec4050a8 (block 26353589) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (40 files): no ecrecover call with literal gas

## Impact and exposure

- Value held at block 26,438,999: $24,001 (ETH and 49 priced tokens).
- Activity: 980 transactions called it in the 90 days before that block; last on 2026-11-17.
- 42 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
