---
id: 24b22b03-sender-gas-limits
title: "0x24b22b03 (tagged deployed by Blockchain Brawlers: Deployer): transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x24b22b031ae1b5a6b09f9a0fd33613a40e0d70e6"
  family: "fcac02a7e5fc258dd467f6a91c7a9d07"
  copies: 2
  label: "deployed by Blockchain Brawlers: Deployer"
  upgradeable: "yes"
  rating: LOW
  value_usd: 38798
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 400
  last_active: 2026-11-18
  recoveries_14d: 20
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
  note: "LOW by nature: gas-limit issue fixed by the sender. value_usd 38798, txs_90d 400, last_active 2026-11-18 (not rating-relevant)."
---

## Summary

deployed by Blockchain Brawlers: Deployer: under EIP-8151 the costlier ecrecover (3,200/6,100 gas) makes some real transactions run out of gas at the sender's chosen limit; the same transactions pass with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x15e59f7b960ce5957e50150ff333472fc295c77ad749c94bfdd2804bbc1735d6 (block 26347740); other transactions of the family pass…. Executed.
- Study replay in row note: tx 0x15e59f7b960ce5957e50150ff333472fc295c77ad749c94bfdd2804bbc1735d6 (block 26347740) fails with sender gas, passes with more; marked Executed
- Passing with more transaction gas shows the ecrecover call is not fixed-gas (a hard-coded stipend would fail regardless)
- no source in dossier; bytecode fetched at block 26438999 (cast code) only

## Impact and exposure

- Value held at block 26,438,999: $38,798 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 400 transactions called it in the 90 days before that block; last on 2026-11-18.
- 20 signature recoveries in the study's two-week trace window.

## Remediation

Senders/wallets re-estimate and raise gas limits; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
