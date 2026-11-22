---
id: c22c479a-sender-gas-limits
title: "0xc22c479a: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xc22c479a54925608cc8cd60fbf69510df31aef26"
  family: "bc362389e03a5a3e193d4847eb2f9f5c"
  copies: 4
  upgradeable: "yes"
  rating: LOW
  value_usd: 15158
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 858
  last_active: 2026-11-18
  recoveries_14d: 58
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 15158, txs_90d 858, last_active 2026-11-18 (not rating-relevant)."
---

## Summary

unnamed contract: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xc2fa5341331ae79c451a0f39c3ae7327f292db82bd6fdead206a19ff40a16f59 (block 26371178). The sender's limit was tight, not the…. Executed.
- Study replay in row note: tx 0xc2fa5341331ae79c451a0f39c3ae7327f292db82bd6fdead206a19ff40a16f59 (block 26371178) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- no source in dossier; bytecode fetched at block 26438999 (cast code) only

## Impact and exposure

- Value held at block 26,438,999: $15,158 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 858 transactions called it in the 90 days before that block; last on 2026-11-18.
- 58 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
