---
id: staking-8a4b4c2a-sender-gas-limits
title: "Staking: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x8a4b4c2acadeaa7206df96f00052e41d74a015ce"
  family: "37608c4734540f4eab0666dc361b4bf2"
  name: "Staking"
  label: "deployed by Celer Network: Deployer 2"
  upgradeable: "no"
  rating: LOW
  txs_90d: 353
  last_active: 2026-11-18
  recoveries_14d: 263
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

`Staking` at `0x8a4b4c2acadeaa7206df96f00052e41d74a015ce` (Etherscan tag: deployed by Celer Network: Deployer 2). A real transaction to it fails under EIP-8151 with its sender's gas limit and succeeds with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x8826c8f4785a9989cc438a9131e44f84fac1c0f17ce9829e5adfd26dc8d53571 (block 26420694); other transactions of the family pass…. Executed.
- Reviewed through the root issue's mechanism (D-025): a real transaction to this contract failed under EIP-8151 with its sender's gas limit and passed when replayed with more gas; the contract forwards all remaining gas to the precompile, so senders raising their gas limit fixes it (LOW)
- A random sample of 25 of the 270 rows below Anon's thresholds was checked one by one: all 25 hold at LOW
- The 132 rows over the thresholds were checked one by one: all LOW

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 353 transactions called it in the 90 days before that block; last on 2026-11-18.
- 263 signature recoveries in the study's two-week trace window.

## Remediation

Whoever sends the transactions adds margin before activation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
