---
id: olinxmessageverifier-31d4753d-sender-gas-limits
title: "OLinxMessageVerifier: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x31d4753dec2a62d2c18ff4ae1d20ad039e3fc4c0"
  family: "890610ee4ce3d3e85aa7aeab3bf629b7"
  copies: 5
  name: "OLinxMessageVerifier"
  upgradeable: "no"
  rating: LOW
  txs_90d: 10
  last_active: 2026-11-17
  recoveries_14d: 7
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

`OLinxMessageVerifier` at `0x31d4753dec2a62d2c18ff4ae1d20ad039e3fc4c0`, with 4 more addresses running its code. A real transaction to it fails under EIP-8151 with its sender's gas limit and succeeds with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xcfa98c79ac682ae7f64351e6426216bbd846a9ac80e3217a1135cd108f2b33d9 (block 26432555). The sender's limit was tight, not the…. Executed.
- Reviewed through the root issue's mechanism: a real transaction to this contract failed under EIP-8151 with its sender's gas limit and passed when replayed with more gas; the contract forwards all remaining gas to the precompile, so senders raising their gas limit fixes it (LOW)
- A random sample of 25 of the 270 rows below Anon's thresholds was checked one by one: all 25 hold at LOW
- The 132 rows over the thresholds were checked one by one: all LOW

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 10 transactions called it in the 90 days before that block; last on 2026-11-17.
- 7 signature recoveries in the study's two-week trace window.

## Remediation

Whoever sends the transactions adds margin before activation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
