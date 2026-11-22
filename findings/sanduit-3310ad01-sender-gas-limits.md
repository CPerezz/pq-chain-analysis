---
id: sanduit-3310ad01-sender-gas-limits
title: "SANDUIT: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x3310ad0117333f3b9d25857949df5a2e0856de3b"
  family: "9101ee9b1bb97a6a208200cf267a85c7"
  copies: 2
  name: "SANDUIT"
  upgradeable: "yes"
  rating: LOW
  value_usd: 361
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 377
  last_active: 2026-11-13
  recoveries_14d: 83
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

SANDUIT: a real transaction runs out of gas under EIP-8151's higher ecrecover cost with the gas limit its sender chose, and succeeds with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xe8510110441b5e3931a711c2e2adb7abdf7ff95aab9a26fc68fd281ae352bf72 (block 26392671); other transactions of the family pass…. Executed.
- row note: replay of 0xe8510110441b5e3931a711c2e2adb7abdf7ff95aab9a26fc68fd281ae352bf72 (block 26392671) failed with the sender's gas limit and passed with more ("Executed")
- verified source (dossier source/): ecrecover is called through Solidity ecrecover/ECDSA; no staticcall to 0x01 with a fixed gas and no {gas: …} on recovery
- txs_90d=377, last_active=2026-11-13, value_usd=361

## Impact and exposure

- Value held at block 26,438,999: $361 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 377 transactions called it in the 90 days before that block; last on 2026-11-13.
- 83 signature recoveries in the study's two-week trace window.

## Remediation

senders and relayers estimate gas again or add margin after EIP-8151; no change to the contract

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
