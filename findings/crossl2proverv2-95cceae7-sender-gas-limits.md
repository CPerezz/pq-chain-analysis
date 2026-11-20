---
id: crossl2proverv2-95cceae7-sender-gas-limits
title: "CrossL2ProverV2: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x95cceae71605c5d97a0ac0ea13013b058729d075"
  family: "eec603a312c7d7fcc50f0a9ff0e128c3"
  copies: 2
  name: "CrossL2ProverV2"
  label: "Polymer: Prover"
  upgradeable: "no"
  rating: LOW
  txs_90d: 18802
  last_active: 2026-11-18
  recoveries_14d: 3935
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd None, txs_90d 18802, last_active 2026-11-18 (not rating-relevant)."
---

## Summary

CrossL2ProverV2: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xf94ebf72622b278fa17d02cf4a518f20eb9664ca5bc28bcdfbfc09568af1c2ea (block 26361392). The sender's limit was tight, not the…. Executed.
- Study replay in row note: tx 0xf94ebf72622b278fa17d02cf4a518f20eb9664ca5bc28bcdfbfc09568af1c2ea (block 26361392) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (1 files): no ecrecover call with literal gas

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 18,802 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3,935 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
