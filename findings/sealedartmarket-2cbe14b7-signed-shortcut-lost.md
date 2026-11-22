---
id: sealedartmarket-2cbe14b7-signed-shortcut-lost
title: "SealedArtMarket: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x2cbe14b7f60fbe6a323cba7db56f2d916c137f3c"
  family: "4b5a2c8efebf6a968e3bac90bc071c7f"
  copies: 2
  name: "SealedArtMarket"
  upgradeable: "no"
  rating: LOW
  value_usd: 22196
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 18
  last_active: 2026-11-02
fix:
  layer: offchain
  who_acts: "users; owner Safe"
evidence:
  level: source-read
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $22196, txs_90d 18."
---

## Summary

SealedArtMarket: bids, sales and withdrawals are checked against signer addresses (bidders, sellers, a sequencer); under EIP-8151 a party with code loses the signed routes.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a sealed-bid art market: its helper returns the signer (read) and the callers compare it with bidders, sellers and a sequencer; by its function names funds leave by a forced withdrawal with a delay,…. Read by hand.
- startWithdrawal / executePendingWithdrawal let msg.sender withdraw after forcedWithdrawDelay without any signature (SealedArtMarket.sol:147-167)
- changeSequencer is onlyOwner (75); emergencyDisableSequencer exists (106)
- owner() at block 26438999 = 0xE4FA009d01B2cd9c9B0F81fd3e45095EF0F1005C, a Safe with threshold 2

## Impact and exposure

- Value held at block 26,438,999: $22,196 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 18 transactions called it in the 90 days before that block; last on 2026-11-02.

## Remediation

Users take the forced withdrawal; the owner Safe can replace the sequencer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
