---
id: 45240118-sender-gas-limits
title: "0x45240118 (tagged deployed by Stake.link: Deployer 1): transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x4524011801bb496deaaf675eed123ed2ba5945d8"
  family: "75dab74aa006b6bb54939dfda325384d"
  label: "deployed by Stake.link: Deployer 1"
  upgradeable: "no"
  rating: LOW
  txs_90d: 80
  last_active: 2026-11-13
  recoveries_14d: 1
fix:
  layer: offchain
  who_acts: "the transaction sender (wallet or relayer setting the gas limit)"
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
  note: "the failure comes from the sender-chosen gas limit, not from gas fixed in the contract, so it is LOW by nature"
---

## Summary

unverified contract: a real transaction runs out of gas under EIP-8151's higher ecrecover cost with the gas limit its sender chose, and succeeds with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x4e72f4585f481a542e6225a6dec6e375395454edceb020349b572493d6348a6e (block 26409178). The sender's limit was tight, not the…. Executed.
- row note: replay of 0x4e72f4585f481a542e6225a6dec6e375395454edceb020349b572493d6348a6e (block 26409178) failed with the sender's gas limit and passed with more ("Executed")
- bytecode (dossier code.hex, no verified source): every STATICCALL takes its gas straight from GAS except one that passes gas/10 to the constant 0x47ebf1da…, not to 0x01; no fixed gas sent to 0x01
- txs_90d=80, last_active=2026-11-13, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 80 transactions called it in the 90 days before that block; last on 2026-11-13.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

senders and relayers estimate gas again or add margin after EIP-8151; no change to the contract

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
