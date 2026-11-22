---
id: 0657bfbf-sender-gas-limits
title: "0x0657bfbf: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x0657bfbf55a72c3ec8f677ef83de443ac9eb097e"
  family: "57cab33ff3ab173b982556f15eae59f1"
  copies: 11
  upgradeable: "no"
  rating: LOW
  value_usd: 23279
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 21
  last_active: 2026-11-17
  recoveries_14d: 6
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 23279, txs_90d 21, last_active 2026-11-17 (not rating-relevant)."
---

## Summary

unnamed contract: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xdd7eba5528438c7d6cf2ef3b68a5f320a66b8b1d1fc937ef97a7f09ada6d014e (block 26433005). The sender's limit was tight, not the…. Executed.
- Study replay in row note: tx 0xdd7eba5528438c7d6cf2ef3b68a5f320a66b8b1d1fc937ef97a7f09ada6d014e (block 26433005) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- no source in dossier; bytecode fetched at block 26438999 (cast code) only

## Impact and exposure

- Value held at block 26,438,999: $23,279 (ETH and 49 priced tokens, over 11 addresses).
- Activity: 21 transactions called it in the 90 days before that block; last on 2026-11-17.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
