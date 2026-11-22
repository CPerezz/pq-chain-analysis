---
id: paxg-45804880-sender-gas-limits
title: "PAXG: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x45804880de22913dafe09f4980848ece6ecbaf78"
  family: "9c1bb3eae284208dab791960560236e1"
  copies: 2
  name: "PAXG"
  label: "Paxos Gold: PAXG Token"
  upgradeable: "yes"
  rating: LOW
  value_usd: 115492
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 293584
  last_active: 2026-11-18
  recoveries_14d: 66
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 115492, txs_90d 293584, last_active 2026-11-18 (not rating-relevant)."
---

## Summary

PAXG: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x70c69205664e913b383c326a477d2aed472bcf66f662fc227813c561c2173e37 (block 26353624). The sender's limit was tight, not the…. Executed.
- Study replay in row note: tx 0x70c69205664e913b383c326a477d2aed472bcf66f662fc227813c561c2173e37 (block 26353624) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (90 files): no ecrecover call with literal gas

## Impact and exposure

- Value held at block 26,438,999: $115,492 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 293,584 transactions called it in the 90 days before that block; last on 2026-11-18.
- 66 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
