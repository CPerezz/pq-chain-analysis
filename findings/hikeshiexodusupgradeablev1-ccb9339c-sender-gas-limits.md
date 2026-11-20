---
id: hikeshiexodusupgradeablev1-ccb9339c-sender-gas-limits
title: "HikeshiExodusUpgradeableV1: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xccb9339c825198a905dc078f40fc1f8e7a1720c7"
  family: "d05c6fed56426aab0dd5edbd0526dd8f"
  copies: 2
  name: "HikeshiExodusUpgradeableV1"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 250
  last_active: 2026-11-07
  recoveries_14d: 2
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code"
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

`HikeshiExodusUpgradeableV1` at `0xccb9339c825198a905dc078f40fc1f8e7a1720c7`, with 1 more addresses running its code. A real transaction to it fails under EIP-8151 with its sender's gas limit and succeeds with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x9f6f432f46769980164d53d4bb816ed4cef3b2449f5138b7e5194d150b2ab70a (block 26363973). The sender's limit was tight, not the…. Executed.
- Reviewed through the root issue's mechanism (D-025): a real transaction to this contract failed under EIP-8151 with its sender's gas limit and passed when replayed with more gas; the contract forwards all remaining gas to the precompile, so senders raising their gas limit fixes it (LOW)
- A random sample of 25 of the 270 rows below Anon's thresholds was checked one by one: all 25 hold at LOW
- The 132 rows over the thresholds were checked one by one: all LOW

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 250 transactions called it in the 90 days before that block; last on 2026-11-07.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

Whoever sends the transactions adds margin before activation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
