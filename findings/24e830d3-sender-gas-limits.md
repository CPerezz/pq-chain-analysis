---
id: 24e830d3-sender-gas-limits
title: "0x24e830d3: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x24e830d3205e08bc124d8de8a3cfea28cab8a313"
  family: "899b80f16ac757c4460f71a720204749"
  upgradeable: "no"
  rating: LOW
  value_usd: 7038
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2437
  last_active: 2026-11-18
  recoveries_14d: 585
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 7038, txs_90d 2437, last_active 2026-11-18 (not rating-relevant)."
---

## Summary

unnamed contract: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xb5af56485e498369b91a9f8a33c589f61dcb5dc39d7a6967101482d6d2879eda (block 26432375). The sender's limit was tight, not the…. Executed.
- Study replay in row note: tx 0xb5af56485e498369b91a9f8a33c589f61dcb5dc39d7a6967101482d6d2879eda (block 26432375) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- no source in dossier; bytecode fetched at block 26438999 (cast code) only

## Impact and exposure

- Value held at block 26,438,999: $7,038 (ETH and 49 priced tokens).
- Activity: 2,437 transactions called it in the 90 days before that block; last on 2026-11-18.
- 585 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
