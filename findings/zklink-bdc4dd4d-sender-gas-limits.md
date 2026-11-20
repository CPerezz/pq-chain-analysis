---
id: zklink-bdc4dd4d-sender-gas-limits
title: "ZklinkFastPool: transactions fail with the sender's gas limit"
project: zklink
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xbdc4dd4d467e55fa5276925b2f136e75df3f86f1"
  family: "fc2a6174f361ce4f000b2b12661aafdc"
  name: "ZklinkFastPool"
  upgradeable: "no"
  rating: LOW
  value_usd: 1423256
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 482
  last_active: 2026-11-18
  recoveries_14d: 110
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 1423256, txs_90d 482, last_active 2026-11-18 (not rating-relevant)."
---

## Summary

ZklinkFastPool: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x59f8291d3269c00a6a1709dc384e312566907c6492fb1f679f5a188533cde379 (block 26410748). The sender's limit was tight, not the…. Executed. Rated by hand: read: 2 of 3 fixed signers move the operator's own liquidity.
- Study replay in row note: tx 0x59f8291d3269c00a6a1709dc384e312566907c6492fb1f679f5a188533cde379 (block 26410748) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (14 files): no ecrecover call with literal gas

## Impact and exposure

- Value held at block 26,438,999: $1.4M (ETH and 49 priced tokens).
- Activity: 482 transactions called it in the 90 days before that block; last on 2026-11-18.
- 110 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
