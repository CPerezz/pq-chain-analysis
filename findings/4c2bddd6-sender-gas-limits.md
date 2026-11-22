---
id: 4c2bddd6-sender-gas-limits
title: "0x4c2bddd6: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x4c2bddd6d3bc89940e0f7a4bd3d43825d03a3ce0"
  family: "b4aa3552fb94a8a272fcb9f0f46ca2ac"
  copies: 272
  upgradeable: "no"
  rating: LOW
  value_usd: 298835
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 7666
  last_active: 2026-11-18
  recoveries_14d: 631
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 298835, txs_90d 7666, last_active 2026-11-18 (not rating-relevant)."
---

## Summary

unnamed contract: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x124ccdeb3562f6d744e071ad5593003766d07b73e499dee8baa12f752e5442c2 (block 26376690); other transactions of the family pass…. Executed.
- Study replay in row note: tx 0x124ccdeb3562f6d744e071ad5593003766d07b73e499dee8baa12f752e5442c2 (block 26376690) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- no source in dossier; bytecode fetched at block 26438999 (cast code) only

## Impact and exposure

- Value held at block 26,438,999: $298,835 (ETH and 49 priced tokens, over 272 addresses).
- Activity: 7,666 transactions called it in the 90 days before that block; last on 2026-11-18.
- 631 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
