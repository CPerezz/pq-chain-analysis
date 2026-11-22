---
id: 7e3abde9-signed-shortcut-lost
title: "0x7e3abde9 (tagged deployed by Baby Shark: Deployer): signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x7e3abde9d9e80fa2d1a02c89e0eae91b233cde35"
  family: "e63c2867f6cbde85031bfb062951f7b8"
  label: "deployed by Baby Shark: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 10827
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4
  last_active: 2026-09-28
fix:
  layer: offchain
  who_acts: "NFT owner with code"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Direct twins exist; read from bytecode. The market is paused at the block, which doesn't change the reading. Value $10827, txs_90d 4 (not rating inputs)."
---

## Summary

An unverified NFT sale/bid market (6 ETH): the OBO (on-behalf) routes acceptBidOffChain, acceptBidByOwnerOBO and createResaleOBO need the NFT owner's signature. The owner keeps direct acceptBid/createSale/cancelSale.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: an NFT bidding market (6 ETH): the on-behalf route is lost for an owner with code. Bytecode and names.
- heimdall + _selectors: acceptBid(uint256,address,uint256) 0xaf8ee37f, createSale 0xab23e6fd, cancelSale 0x813d2ad8, cancelBid, purchase, withdrawFunds present
- facts getters: paused() = 1 at the block; owner 0xc03fa0fa… (transferOwnership, pause/unpause)

## Impact and exposure

- Value held at block 26,438,999: $10,827 (ETH and 49 priced tokens).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-09-28.

## Remediation

The NFT owner uses acceptBid/createSale directly (once the owner unpauses).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
