---
id: paymentplanv2logic-e803684b-sender-gas-limits
title: "PaymentPlanV2Logic: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xe803684b9e391d01dc1cdf76bac9ae3a596b2ae0"
  family: "fc7c0b127371423b27634fc8c0200623"
  copies: 5
  name: "PaymentPlanV2Logic"
  label: "deployed by Cyan: Deployer"
  upgradeable: "yes"
  rating: LOW
  value_usd: 3790
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 164
  last_active: 2026-11-16
  recoveries_14d: 15
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
  note: "reviewed through the root issue's mechanism and a random sample"
---

## Summary

`PaymentPlanV2Logic` at `0xe803684b9e391d01dc1cdf76bac9ae3a596b2ae0` (Etherscan tag: deployed by Cyan: Deployer), with 4 more addresses running its code. A real transaction to it fails under EIP-8151 with its sender's gas limit and succeeds with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x04d2fed394b4f7c88cc27d1db51011b759eddd2c86f8290c230f18f82015256b (block 26342846). The sender's limit was tight, not the…. Executed.
- Reviewed through the root issue's mechanism: a real transaction to this contract failed under EIP-8151 with its sender's gas limit and passed when replayed with more gas; the contract forwards all remaining gas to the precompile, so senders raising their gas limit fixes it (LOW)
- A random sample of 25 of the 270 rows below Anon's thresholds was checked one by one: all 25 hold at LOW
- The 132 rows over the thresholds were checked one by one: all LOW

## Impact and exposure

- Value held at block 26,438,999: $3,790 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 164 transactions called it in the 90 days before that block; last on 2026-11-16.
- 15 signature recoveries in the study's two-week trace window.

## Remediation

Whoever sends the transactions adds margin before activation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
