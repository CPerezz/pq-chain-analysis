---
id: b122017e-sender-gas-limits
title: "0xb122017e (tagged deployed by Bitget Wallet: Deployer 2): transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xb122017e36d1b4c5524c32257da9f90a0e882c8f"
  family: "8fe0d4ef007f0c2cd306569e562c31da"
  copies: 129531
  label: "deployed by Bitget Wallet: Deployer 2"
  upgradeable: "no"
  rating: LOW
  value_usd: 57848419
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 554554
  last_active: 2026-11-18
  recoveries_14d: 439
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 57848419, txs_90d 554554, last_active 2026-11-18 (not rating-relevant)."
---

## Summary

deployed by Bitget Wallet: Deployer 2: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x89ec9a8a0670dd3d454e62316436b917d78802e5dbe68b5c5c8265343167c1cb (block 26398219); other transactions of the family pass…. Executed.
- Study replay in row note: tx 0x89ec9a8a0670dd3d454e62316436b917d78802e5dbe68b5c5c8265343167c1cb (block 26398219) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- no source in dossier; bytecode fetched at block 26438999 (cast code) only

## Impact and exposure

- Value held at block 26,438,999: $57.8M (ETH and 49 priced tokens, over 129,531 addresses).
- Activity: 554,554 transactions called it in the 90 days before that block; last on 2026-11-18.
- 439 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
