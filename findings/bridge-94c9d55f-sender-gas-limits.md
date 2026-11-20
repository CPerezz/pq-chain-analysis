---
id: bridge-94c9d55f-sender-gas-limits
title: "Bridge: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x94c9d55f064980ed1faf0abb42f3548700619039"
  family: "6fb6da97e90112380370e0f619f23191"
  copies: 6
  name: "Bridge"
  upgradeable: "yes"
  rating: LOW
  value_usd: 70017
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 73
  last_active: 2026-11-16
  recoveries_14d: 7
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 70017, txs_90d 73, last_active 2026-11-16 (not rating-relevant)."
---

## Summary

Bridge: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x8f4fc360766a86aa7bf875016c078d4e90d56759f2e05f4cc2bbd3b6143f4226 (block 26406219). The sender's limit was tight, not the…. Executed.
- Study replay in row note: tx 0x8f4fc360766a86aa7bf875016c078d4e90d56759f2e05f4cc2bbd3b6143f4226 (block 26406219) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (31 files): no ecrecover call with literal gas

## Impact and exposure

- Value held at block 26,438,999: $70,017 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 73 transactions called it in the 90 days before that block; last on 2026-11-16.
- 7 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
