---
id: compressedoraclev1-369f19ba-sender-gas-limits
title: "CompressedOracleV1: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x369f19ba423493f0457431d39417e6f6e0c875ff"
  family: "d0e339c9814711196974bf74b66885e3"
  copies: 3
  name: "CompressedOracleV1"
  upgradeable: "no"
  rating: LOW
  txs_90d: 304479
  last_active: 2026-11-18
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd None, txs_90d 304479, last_active 2026-11-18 (not rating-relevant)."
---

## Summary

CompressedOracleV1: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x775ea22d7e281779d6068e71d2d488d263f2745a2f35a9d960fb707e0bba114e (block 26433723); other transactions of the family pass…. Executed.
- Study replay in row note: tx 0x775ea22d7e281779d6068e71d2d488d263f2745a2f35a9d960fb707e0bba114e (block 26433723) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (21 files): no ecrecover call with literal gas

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 304,479 transactions called it in the 90 days before that block; last on 2026-11-18.
- 7 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
