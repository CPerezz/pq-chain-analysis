---
id: bridge-a3a3e830-sender-gas-limits
title: "Bridge: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xa3a3e8304c88b017153ba5dfccdaccb7116a185f"
  family: "012c8e40cde05f719308f5efab3b3134"
  name: "Bridge"
  upgradeable: "no"
  rating: LOW
  txs_90d: 90
  last_active: 2026-11-18
  recoveries_14d: 51
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

Bridge: a real transaction runs out of gas under EIP-8151's higher ecrecover cost with the gas limit its sender chose, and succeeds with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xf1d91bbe88b84b9a746010fdc9bec76801769d5dce37483915f8d7802a5d26d3 (block 26396646); other transactions of the family pass…. Executed.
- row note: replay of 0xf1d91bbe88b84b9a746010fdc9bec76801769d5dce37483915f8d7802a5d26d3 (block 26396646) failed with the sender's gas limit and passed with more ("Executed")
- verified source (dossier source/): ecrecover is called through Solidity ecrecover/ECDSA; no staticcall to 0x01 with a fixed gas and no {gas: …} on recovery
- txs_90d=90, last_active=2026-11-18, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 90 transactions called it in the 90 days before that block; last on 2026-11-18.
- 51 signature recoveries in the study's two-week trace window.

## Remediation

senders and relayers estimate gas again or add margin after EIP-8151; no change to the contract

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
