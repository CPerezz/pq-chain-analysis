---
id: gnosissafe-02479bfc-sender-gas-limits
title: "GnosisSafe: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x02479bfc7dce53a02e26fe7baea45a0852cb0909"
  family: "f15632f51822929a9fbf0492ef338d70"
  copies: 749
  name: "GnosisSafe"
  label: "created by Safe: Proxy Factory 1.1.1"
  upgradeable: "yes"
  rating: LOW
  value_usd: 377694
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 85
  last_active: 2026-11-10
  recoveries_14d: 3
fix:
  layer: offchain
  who_acts: "transaction sender / wallet (raise gas limit)"
evidence:
  level: source-read
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 377694, txs_90d 85, last_active 2026-11-10 (not rating-relevant)."
---

## Summary

GnosisSafe: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x3c2cd1ec2ba214421015efd3f17840bf713e938d10b16acecebe8b9201b88f3c (block 26385195). The sender's limit was tight, not the…. Executed.
- Study replay in row note: tx 0x3c2cd1ec2ba214421015efd3f17840bf713e938d10b16acecebe8b9201b88f3c (block 26385195) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- verified source in dossier (13 files): no ecrecover call with literal gas

## Impact and exposure

- Value held at block 26,438,999: $377,694 (ETH and 49 priced tokens, over 749 addresses).
- Activity: 85 transactions called it in the 90 days before that block; last on 2026-11-10.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
