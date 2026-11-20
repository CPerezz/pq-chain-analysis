---
id: bonkeenft-c600cfef-sender-gas-limits
title: "BonkeeNFT: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xc600cfef0dc2ae41a7f3b67e52cf2578025cf777"
  family: "db14743fedb31a643c64ef7e769921bb"
  name: "BonkeeNFT"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2
  last_active: 2026-11-05
  recoveries_14d: 2
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

BonkeeNFT: a real transaction runs out of gas under EIP-8151's higher ecrecover cost with the gas limit its sender chose, and succeeds with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x3482dc412a5cc36f82028750ee0daa0fa051cda114c9347eaf26d5c08c96c014 (block 26348758). The sender's limit was tight, not the…. Executed.
- row note: replay of 0x3482dc412a5cc36f82028750ee0daa0fa051cda114c9347eaf26d5c08c96c014 (block 26348758) failed with the sender's gas limit and passed with more ("Executed")
- verified source (dossier source/): ecrecover is called through Solidity ecrecover/ECDSA; no staticcall to 0x01 with a fixed gas and no {gas: …} on recovery
- txs_90d=2, last_active=2026-11-05, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-05.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

senders and relayers estimate gas again or add margin after EIP-8151; no change to the contract

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
