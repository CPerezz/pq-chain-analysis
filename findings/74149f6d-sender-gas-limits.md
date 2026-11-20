---
id: 74149f6d-sender-gas-limits
title: "0x74149f6d (tagged deployed by Earthmeta: Deployer): transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x74149f6d0dbdbe356fd8035a83dbc0ab7c4c1a8e"
  family: "532c367548d997e832471dbc20b5b27f"
  copies: 2
  label: "deployed by Earthmeta: Deployer"
  upgradeable: "yes"
  rating: LOW
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 298
  last_active: 2026-11-18
  recoveries_14d: 25
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

Contract `0x74149f6d0dbdbe356fd8035a83dbc0ab7c4c1a8e` (Etherscan tag: deployed by Earthmeta: Deployer), with 1 more addresses running its code. A real transaction to it fails under EIP-8151 with its sender's gas limit and succeeds with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x47bac3fe30d2004e5c391e15f47b59d9143563a74eb76e5698f885573298db86 (block 26408548); other transactions of the family pass…. Executed.
- Reviewed through the root issue's mechanism (D-025): a real transaction to this contract failed under EIP-8151 with its sender's gas limit and passed when replayed with more gas; the contract forwards all remaining gas to the precompile, so senders raising their gas limit fixes it (LOW)
- A random sample of 25 of the 270 rows below Anon's thresholds was checked one by one: all 25 hold at LOW
- The 132 rows over the thresholds were checked one by one: all LOW

## Impact and exposure

- Value held at block 26,438,999: $902 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 298 transactions called it in the 90 days before that block; last on 2026-11-18.
- 25 signature recoveries in the study's two-week trace window.

## Remediation

Whoever sends the transactions adds margin before activation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
