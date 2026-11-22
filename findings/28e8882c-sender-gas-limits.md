---
id: 28e8882c-sender-gas-limits
title: "0x28e8882c: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x28e8882c7e23bc5e3b94c64df34b6e45738a14b9"
  family: "15c107bbdd3613ba5ef7deaed5296902"
  upgradeable: "no"
  rating: LOW
  value_usd: 34106
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 426
  last_active: 2026-11-17
  recoveries_14d: 17
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 34106, txs_90d 426, last_active 2026-11-17 (not rating-relevant)."
---

## Summary

unnamed contract: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x8da20597c2b4aab4efb39ee6ec813c1311fcbc88772fbcf32eca973942e6ccd6 (block 26427621); other transactions of the family pass…. Executed.
- Study replay in row note: tx 0x8da20597c2b4aab4efb39ee6ec813c1311fcbc88772fbcf32eca973942e6ccd6 (block 26427621) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- no source in dossier; bytecode fetched at block 26438999 (cast code) only

## Impact and exposure

- Value held at block 26,438,999: $34,106 (ETH and 49 priced tokens).
- Activity: 426 transactions called it in the 90 days before that block; last on 2026-11-17.
- 17 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
