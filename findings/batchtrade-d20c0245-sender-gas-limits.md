---
id: batchtrade-d20c0245-sender-gas-limits
title: "BatchTrade: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xd20c024560cca40288c05bab650ac087ae9b0f6e"
  family: "0eb672e90cf44aa24378f59648641967"
  name: "BatchTrade"
  label: "31Third: Batch Trade"
  upgradeable: "no"
  rating: LOW
  value_usd: 11730
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2157
  last_active: 2026-11-17
  recoveries_14d: 166
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 11730, txs_90d 2157, last_active 2026-11-17 (not rating-relevant)."
---

## Summary

BatchTrade: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xe1fea8c66a8cc81837a011b5dcf7a385c52eae81a208f6d8b97247642c2ccac4 (block 26426840); other transactions of the family pass…. Executed.
- Study replay in row note: tx 0xe1fea8c66a8cc81837a011b5dcf7a385c52eae81a208f6d8b97247642c2ccac4 (block 26426840) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (15 files): no ecrecover call with literal gas

## Impact and exposure

- Value held at block 26,438,999: $11,730 (ETH and 49 priced tokens).
- Activity: 2,157 transactions called it in the 90 days before that block; last on 2026-11-17.
- 166 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
