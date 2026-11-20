---
id: f57760c0-sender-gas-limits
title: "0xf57760c0: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xf57760c0f36cd701d46baea3c4319a69a7c16df7"
  family: "d3f7b119590476b357197c8c43643b77"
  upgradeable: "no"
  rating: LOW
  txs_90d: 595
  last_active: 2026-11-18
  recoveries_14d: 478
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

Contract `0xf57760c0f36cd701d46baea3c4319a69a7c16df7`. A real transaction to it fails under EIP-8151 with its sender's gas limit and succeeds with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x63d229be5150b8312f22ae9ed0a584ff05db5252b533db4107ecf293d6378a7b (block 26423862). The sender's limit was tight, not the…. Executed.
- Reviewed through the root issue's mechanism (D-025): a real transaction to this contract failed under EIP-8151 with its sender's gas limit and passed when replayed with more gas; the contract forwards all remaining gas to the precompile, so senders raising their gas limit fixes it (LOW)
- A random sample of 25 of the 270 rows below Anon's thresholds was checked one by one: all 25 hold at LOW
- The 132 rows over the thresholds were checked one by one: all LOW

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 595 transactions called it in the 90 days before that block; last on 2026-11-18.
- 478 signature recoveries in the study's two-week trace window.

## Remediation

Whoever sends the transactions adds margin before activation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
