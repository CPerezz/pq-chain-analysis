---
id: safel2-f4ac5a5d-sender-gas-limits
title: "SafeL2: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xf4ac5a5dc1543086347d28e757091ebd1b848cca"
  family: "9a69c84f36e5dc4b8bd01609501dd9e6"
  copies: 39586
  name: "SafeL2"
  label: "deployed by Candide: Bundler 1"
  upgradeable: "yes"
  rating: LOW
  value_usd: 88489848
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 55807
  last_active: 2026-11-18
  recoveries_14d: 4395
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 88489848, txs_90d 55807, last_active 2026-11-18 (not rating-relevant)."
---

## Summary

SafeL2: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xcca69e3dab7f1962fb8cccd8001704427e6af58e5352773fa77c93aed9db3674 (block 26342415); other transactions of the family pass…. Executed.
- Study replay in row note: tx 0xcca69e3dab7f1962fb8cccd8001704427e6af58e5352773fa77c93aed9db3674 (block 26342415) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (55 files): no ecrecover call with literal gas; only {gas:100000} hit is in MockContract.sol, a test file

## Impact and exposure

- Value held at block 26,438,999: $88.5M (ETH and 49 priced tokens, over 39,586 addresses).
- Activity: 55,807 transactions called it in the 90 days before that block; last on 2026-11-18.
- 4,395 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
