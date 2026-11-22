---
id: zebeccard-aa0878e3-sender-gas-limits
title: "ZebecCard: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xaa0878e38caeafc390876479f5a14c4705c7a54a"
  family: "dd7a01fd6375c68c90a66802fbaa739f"
  copies: 2
  name: "ZebecCard"
  upgradeable: "yes"
  rating: LOW
  value_usd: 2346
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 325
  last_active: 2026-11-18
  recoveries_14d: 8
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

ZebecCard: a real transaction runs out of gas under EIP-8151's higher ecrecover cost with the gas limit its sender chose, and succeeds with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x9900d8295f6e37e7845262707baed0dddc307011f4a8b059445f8ceb93217d80 (block 26435614); other transactions of the family pass…. Executed.
- row note: replay of 0x9900d8295f6e37e7845262707baed0dddc307011f4a8b059445f8ceb93217d80 (block 26435614) failed with the sender's gas limit and passed with more ("Executed")
- verified source (dossier source/): ecrecover is called through Solidity ecrecover/ECDSA; no staticcall to 0x01 with a fixed gas and no {gas: …} on recovery
- txs_90d=325, last_active=2026-11-18, value_usd=2346

## Impact and exposure

- Value held at block 26,438,999: $2,346 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 325 transactions called it in the 90 days before that block; last on 2026-11-18.
- 8 signature recoveries in the study's two-week trace window.

## Remediation

senders and relayers estimate gas again or add margin after EIP-8151; no change to the contract

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
