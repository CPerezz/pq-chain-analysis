---
id: tethertoken-93d07077-sender-gas-limits
title: "TetherToken: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x93d070772066c977d605d69b602d316adafc25e3"
  family: "57df7c13b8e7a2be124845948fb20764"
  copies: 4
  name: "TetherToken"
  label: "deployed by DeversiFi: Deployer 2"
  upgradeable: "yes"
  rating: LOW
  value_usd: 541
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 356501
  last_active: 2026-11-18
  recoveries_14d: 217
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 541, txs_90d 356501, last_active 2026-11-18 (not rating-relevant)."
---

## Summary

TetherToken: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x499a52792d8523acfb3a2e58ae2de9770343ba6fb5aa023b5cc4d83230d7b4ef (block 26353709); other transactions of the family pass…. Executed.
- Study replay in row note: tx 0x499a52792d8523acfb3a2e58ae2de9770343ba6fb5aa023b5cc4d83230d7b4ef (block 26353709) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (13 files): no ecrecover call with literal gas

## Impact and exposure

- Value held at block 26,438,999: $541 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 356,501 transactions called it in the 90 days before that block; last on 2026-11-18.
- 217 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
