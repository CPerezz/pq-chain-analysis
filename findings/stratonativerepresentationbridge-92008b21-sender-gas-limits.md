---
id: stratonativerepresentationbridge-92008b21-sender-gas-limits
title: "StratoNativeRepresentationBridge: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x92008b210e3d5e03370e5d372843a6439196d37f"
  family: "7485633554fd3c1593ec6406651b4c45"
  copies: 2
  name: "StratoNativeRepresentationBridge"
  label: "deployed by STRATO GOLDST Tokenized Gold: Deployer"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 159
  last_active: 2026-11-16
  recoveries_14d: 7
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

`StratoNativeRepresentationBridge` at `0x92008b210e3d5e03370e5d372843a6439196d37f` (Etherscan tag: deployed by STRATO GOLDST Tokenized Gold: Deployer), with 1 more addresses running its code. A real transaction to it fails under EIP-8151 with its sender's gas limit and succeeds with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xddbcfcbd9a2cb35a3c00640cfa392ac8e01f5af9a7638abc6110d3fe4b1db71b (block 26393421). The sender's limit was tight, not the…. Executed.
- Reviewed through the root issue's mechanism: a real transaction to this contract failed under EIP-8151 with its sender's gas limit and passed when replayed with more gas; the contract forwards all remaining gas to the precompile, so senders raising their gas limit fixes it (LOW)
- A random sample of 25 of the 270 rows below Anon's thresholds was checked one by one: all 25 hold at LOW
- The 132 rows over the thresholds were checked one by one: all LOW

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 159 transactions called it in the 90 days before that block; last on 2026-11-16.
- 7 signature recoveries in the study's two-week trace window.

## Remediation

Whoever sends the transactions adds margin before activation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
