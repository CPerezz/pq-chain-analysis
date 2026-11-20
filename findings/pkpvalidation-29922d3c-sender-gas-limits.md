---
id: pkpvalidation-29922d3c-sender-gas-limits
title: "PKPValidation: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x29922d3ccb86516f6c24f89f1eb3068655ca7fa0"
  family: "5f41cb3e83a27ae54b33cac4df4262e6"
  copies: 2
  name: "PKPValidation"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 52
  last_active: 2026-11-10
  recoveries_14d: 1
fix:
  layer: offchain
  who_acts: "the transaction sender (wallet or relayer setting the gas limit)"
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
  note: "the failure comes from the sender-chosen gas limit, not from gas fixed in the contract, so it is LOW by nature"
---

## Summary

PKPValidation: a real transaction runs out of gas under EIP-8151's higher ecrecover cost with the gas limit its sender chose, and succeeds with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x89ffab2f7bab60c6ca9ee53dd0f7439d15220c475a33c69f9e85efd300c6e9d7 (block 26348309). The sender's limit was tight, not the…. Executed.
- row note: replay of 0x89ffab2f7bab60c6ca9ee53dd0f7439d15220c475a33c69f9e85efd300c6e9d7 (block 26348309) failed with the sender's gas limit and passed with more ("Executed")
- verified source (dossier source/): ecrecover is called through Solidity ecrecover/ECDSA; no staticcall to 0x01 with a fixed gas and no {gas: …} on recovery
- txs_90d=52, last_active=2026-11-10, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 52 transactions called it in the 90 days before that block; last on 2026-11-10.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

senders and relayers estimate gas again or add margin after EIP-8151; no change to the contract

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
