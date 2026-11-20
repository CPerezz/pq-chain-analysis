---
id: 6fb5a994-sender-gas-limits
title: "0x6fb5a994: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x6fb5a99485621b695d5e895838ff882f41743a9a"
  family: "a11993ab6481f4cd8087dc5187470185"
  upgradeable: "no"
  rating: LOW
  value_usd: 1083
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 59
  last_active: 2026-11-17
  recoveries_14d: 4
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
  note: "reviewed through the root issue's mechanism and a random sample (D-025)"
---

## Summary

Contract `0x6fb5a99485621b695d5e895838ff882f41743a9a`. A real transaction to it fails under EIP-8151 with its sender's gas limit and succeeds with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x77f18578c103eddc870f3c085b0fe8dc79a3d60e5186bfc4ff1d8626a0f5c4c4 (block 26432473). The sender's limit was tight, not the…. Executed.
- Reviewed through the root issue's mechanism (D-025): a real transaction to this contract failed under EIP-8151 with its sender's gas limit and passed when replayed with more gas; the contract forwards all remaining gas to the precompile, so senders raising their gas limit fixes it (LOW)
- A random sample of 25 of the 270 rows below Anon's thresholds was checked one by one: all 25 hold at LOW
- The 132 rows over the thresholds were checked one by one: all LOW

## Impact and exposure

- Value held at block 26,438,999: $1,083 (ETH and 49 priced tokens).
- Activity: 59 transactions called it in the 90 days before that block; last on 2026-11-17.
- 4 signature recoveries in the study's two-week trace window.

## Remediation

Whoever sends the transactions adds margin before activation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
