---
id: oxideportal-cb99c58f-sender-gas-limits
title: "OxidePortal: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xcb99c58fe81ae6b2cb4835e46f7b703745879042"
  family: "30acf8f4fa7c18bb19e5ed020a2a130b"
  copies: 3
  name: "OxidePortal"
  upgradeable: "no"
  rating: LOW
  value_usd: 61535
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 993
  last_active: 2026-11-17
  recoveries_14d: 201
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 61535, txs_90d 993, last_active 2026-11-17 (not rating-relevant)."
---

## Summary

OxidePortal: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x70f288afc756ae2c116898a2d205c80e21c59a546fd905ef8fb00f35dc46abe2 (block 26389685); other transactions of the family pass…. Executed.
- Study replay in row note: tx 0x70f288afc756ae2c116898a2d205c80e21c59a546fd905ef8fb00f35dc46abe2 (block 26389685) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (102 files): no ecrecover call with literal gas

## Impact and exposure

- Value held at block 26,438,999: $61,535 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 993 transactions called it in the 90 days before that block; last on 2026-11-17.
- 201 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
