---
id: digighostssummoned-c6a043a9-sender-gas-limits
title: "DigiGhostsSummoned: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xc6a043a97986eabc761db0616513546043ee489a"
  family: "39ea14ba2c872ac05168c616a3b5a87c"
  name: "DigiGhostsSummoned"
  upgradeable: "no"
  rating: LOW
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 214
  last_active: 2026-11-17
  recoveries_14d: 100
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

`DigiGhostsSummoned` at `0xc6a043a97986eabc761db0616513546043ee489a`. A real transaction to it fails under EIP-8151 with its sender's gas limit and succeeds with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x56e915f7392da84a0ce7e176ad0a97cac092c03ef9cc3cd3559c2871e03e5024 (block 26382720); other transactions of the family pass…. Executed.
- Reviewed through the root issue's mechanism (D-025): a real transaction to this contract failed under EIP-8151 with its sender's gas limit and passed when replayed with more gas; the contract forwards all remaining gas to the precompile, so senders raising their gas limit fixes it (LOW)
- A random sample of 25 of the 270 rows below Anon's thresholds was checked one by one: all 25 hold at LOW
- The 132 rows over the thresholds were checked one by one: all LOW

## Impact and exposure

- Value held at block 26,438,999: $180 (ETH and 49 priced tokens).
- Activity: 214 transactions called it in the 90 days before that block; last on 2026-11-17.
- 100 signature recoveries in the study's two-week trace window.

## Remediation

Whoever sends the transactions adds margin before activation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
