---
id: ambire-fde6d730-sender-gas-limits
title: "AmbireAccount: transactions fail with the sender's gas limit"
project: ambire
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xfde6d7303868fd2046c15263c9268618092664d1"
  family: "8ec52cac940e80d135861a45ae4824b4"
  copies: 405
  name: "AmbireAccount"
  label: "deployed by Ambire Wallet: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 1135610
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1156
  last_active: 2026-11-17
  recoveries_14d: 165
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 1135610, txs_90d 1156, last_active 2026-11-17 (not rating-relevant)."
---

## Summary

AmbireAccount: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xe39ba18c4e00e92b28685cbcefaafccab8cd898ca793ae0ae6bfbc1c2d5cac27 (block 26390609); other transactions of the family pass…. Executed. Rated by hand: the fixed key is Ambire's paymaster relayer; the accounts' own keys can be replaced.
- Study replay in row note: tx 0xe39ba18c4e00e92b28685cbcefaafccab8cd898ca793ae0ae6bfbc1c2d5cac27 (block 26390609) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (12 files): no ecrecover call with literal gas

## Impact and exposure

- Value held at block 26,438,999: $1.1M (ETH and 49 priced tokens, over 405 addresses).
- Activity: 1,156 transactions called it in the 90 days before that block; last on 2026-11-17.
- 165 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
