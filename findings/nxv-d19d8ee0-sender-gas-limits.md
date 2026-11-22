---
id: nxv-d19d8ee0-sender-gas-limits
title: "NXV: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xd19d8ee0a736bf643f53e3dc5489ac94e947a482"
  family: "e41c77f855610a70e75dafea9fe77662"
  copies: 80
  name: "NXV"
  upgradeable: "yes"
  rating: LOW
  value_usd: 12187637
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 576
  last_active: 2026-11-18
  recoveries_14d: 95
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 12187637, txs_90d 576, last_active 2026-11-18 (not rating-relevant)."
---

## Summary

NXV: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x287d982e3b39dead4f0b72c5a1e69d6440a96d478bf42c3c68a4c7ecd2734435 (block 26438947). The sender's limit was tight, not the…. Executed.
- Study replay in row note: tx 0x287d982e3b39dead4f0b72c5a1e69d6440a96d478bf42c3c68a4c7ecd2734435 (block 26438947) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (13 files): no ecrecover call with literal gas

## Impact and exposure

- Value held at block 26,438,999: $12.2M (ETH and 49 priced tokens, over 80 addresses).
- Activity: 576 transactions called it in the 90 days before that block; last on 2026-11-18.
- 95 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
