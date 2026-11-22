---
id: allowancemodule-cfbfac74-sender-gas-limits
title: "AllowanceModule: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xcfbfac74c26f8647cbdb8c5caf80bb5b32e43134"
  family: "7c7cca9024a5bbd73a85e2c37860cd23"
  name: "AllowanceModule"
  label: "deployed by Safe: Deployer 3"
  upgradeable: "no"
  rating: LOW
  value_usd: 9925
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2179
  last_active: 2026-11-18
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 9925, txs_90d 2179, last_active 2026-11-18 (not rating-relevant)."
---

## Summary

AllowanceModule: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x97afbffd703dda92bf193da501598c0838b8acd36671de5a7541a78c0a5fb2bd (block 26348149). The sender's limit was tight, not the…. Executed.
- Study replay in row note: tx 0x97afbffd703dda92bf193da501598c0838b8acd36671de5a7541a78c0a5fb2bd (block 26348149) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (3 files): no ecrecover call with literal gas

## Impact and exposure

- Value held at block 26,438,999: $9,925 (ETH and 49 priced tokens).
- Activity: 2,179 transactions called it in the 90 days before that block; last on 2026-11-18.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
