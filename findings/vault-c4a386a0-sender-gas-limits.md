---
id: vault-c4a386a0-sender-gas-limits
title: "Vault: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xc4a386a0fc1910d60a5283001b6c94efc20e229c"
  family: "d6883c1decaaf3905d3448b5b998acf9"
  copies: 4
  name: "Vault"
  label: "Onrail: Core Vault"
  upgradeable: "no"
  rating: LOW
  value_usd: 8662
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 45
  last_active: 2026-11-10
  recoveries_14d: 5
fix:
  layer: offchain
  who_acts: "whoever sends the transactions raises the gas limit"
evidence:
  level: executed
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
  note: "reviewed through the root issue's mechanism and a random sample"
---

## Summary

`Vault` at `0xc4a386a0fc1910d60a5283001b6c94efc20e229c` (Etherscan tag: Onrail: Core Vault), with 3 more addresses running its code. A real transaction to it fails under EIP-8151 with its sender's gas limit and succeeds with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xde869231cbe6a4e8f04e862cacef6a57aeca86a08a99db2c8950d0af9c5dfd22 (block 26386085). The sender's limit was tight, not the…. Executed.
- Reviewed through the root issue's mechanism: a real transaction to this contract failed under EIP-8151 with its sender's gas limit and passed when replayed with more gas; the contract forwards all remaining gas to the precompile, so senders raising their gas limit fixes it (LOW)
- A random sample of 25 of the 270 rows below Anon's thresholds was checked one by one: all 25 hold at LOW
- The 132 rows over the thresholds were checked one by one: all LOW

## Impact and exposure

- Value held at block 26,438,999: $8,662 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 45 transactions called it in the 90 days before that block; last on 2026-11-10.
- 5 signature recoveries in the study's two-week trace window.

## Remediation

Whoever sends the transactions adds margin before activation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
