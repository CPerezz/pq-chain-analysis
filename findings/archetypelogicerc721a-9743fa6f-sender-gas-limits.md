---
id: archetypelogicerc721a-9743fa6f-sender-gas-limits
title: "ArchetypeLogicErc721a: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x9743fa6fce7e50e182951dcfdac65c9d95494f97"
  family: "b05115a9ece0061e7fb0a5e9845238ce"
  copies: 511
  name: "ArchetypeLogicErc721a"
  upgradeable: "no"
  rating: LOW
  value_usd: 5414
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6653
  last_active: 2026-11-18
  recoveries_14d: 12
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 5414, txs_90d 6653, last_active 2026-11-18 (not rating-relevant)."
---

## Summary

ArchetypeLogicErc721a: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x0fbc80f479af7343431ba41cecce0ddb8b363fc9b68f2e00ae84e7171628d60c (block 26426621). The sender's limit was tight, not the…. Executed.
- Study replay in row note: tx 0x0fbc80f479af7343431ba41cecce0ddb8b363fc9b68f2e00ae84e7171628d60c (block 26426621) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (7 files): no ecrecover call with literal gas

## Impact and exposure

- Value held at block 26,438,999: $5,414 (ETH and 49 priced tokens, over 511 addresses).
- Activity: 6,653 transactions called it in the 90 days before that block; last on 2026-11-18.
- 12 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
